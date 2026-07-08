{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cudaPackages,
  cudatoolkit,
  vapoursynth,
  config,
  cudaSupport ? config.cudaSupport,
}: let
  # Use tensorrt 10.16.1.11 to have the fix for CVE-2026-24188.
  tensorrt = cudaPackages.tensorrt.overrideAttrs (prevAttrs: {
    passthru =
      prevAttrs.passthru
      // {
        release = {
          version = "10.16.1.11";
          cuda_variant = [
            "12"
            "13"
          ];
          linux-x86_64 = {
            cuda12 = {
              relative_path = "tensorrt/10.16.1/tars/TensorRT-10.16.1.11.Linux.x86_64-gnu.cuda-12.9.tar.gz";
              sha256 = "48e64fc9231fe3aeaa18be13385b486ea7c7131dd64f09b54e5fcb051386f014";
            };
            cuda13 = {
              relative_path = "tensorrt/10.16.1/tars/TensorRT-10.16.1.11.Linux.x86_64-gnu.cuda-13.2.tar.gz";
              sha256 = "08334948c57c3bcf2de171ef4bd53d15f48a61a942b048abea12e32f892284e8";
            };
          };
          linux-sbsa = {
            cuda13 = {
              relative_path = "tensorrt/10.16.1/tars/TensorRT-10.16.1.11.Linux.aarch64-gnu.cuda-13.2.tar.gz";
              sha256 = "63ecfb16d2df932cc5c3f2a362ae6281919f565c5ca3a5e1299c95780e165c91";
            };
          };
        };
      };
  });
in
  stdenv.mkDerivation rec {
    pname = "trt";
    # renovate: datasource=github-releases depName=AmusementClub/vs-mlrt
    version = "15.16";

    src = fetchFromGitHub {
      owner = "AmusementClub";
      repo = "vs-mlrt";
      rev = "v${version}";
      sha256 = "sha256-mcIPNrPsVNgtGSSzLpwm7QYEbFOcB6IH2pepS9pVGCc=";
    };

    sourceRoot = "source/vstrt";

    patches = [
      ./no-git.patch
    ];

    nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      tensorrt
      cudatoolkit
      vapoursynth
    ];

    strictDeps = true;

    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "CUDA::cudart_static" "CUDA::cudart"
    '';

    cmakeFlags = [
      "-DVCS_TAG=v${version}"
      "-DCMAKE_CXX_FLAGS=-I${vapoursynth}/include/vapoursynth"
      "-DCMAKE_SKIP_RPATH=ON"
    ];

    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      ln -s $out/lib/libvstrt${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth
    '';

    meta = with lib; {
      description = "VapourSynth TensorRT";
      homepage = "https://github.com/AmusementClub/vs-mlrt/tree/master/vstrt";
      license = licenses.gpl3;
      badPlatforms = optionals (!cudaSupport) platforms.all;
      broken = !cudaSupport;
      platforms = optionals cudaSupport platforms.all;
    };
  }
