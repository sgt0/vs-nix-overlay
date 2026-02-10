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
}:
stdenv.mkDerivation rec {
  pname = "trt";
  # renovate: datasource=github-releases depName=AmusementClub/vs-mlrt
  version = "15.15";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v${version}";
    sha256 = "sha256-g8F1mw+Q+1ZkCuZs6dTn1Dffq3OPyE/8bXqGvrAHxfs=";
  };

  sourceRoot = "source/vstrt";

  patches = [
    ./no-git.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    cudaPackages.tensorrt
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
