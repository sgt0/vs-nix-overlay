{
  lib,
  fetchFromGitHub,
  cmake,
  cudaPackages_12,
  vapoursynth,
  config,
  cudaSupport ? config.cudaSupport,
}:
cudaPackages_12.backendStdenv.mkDerivation rec {
  pname = "nlm_cuda";
  # renovate: datasource=github-releases depName=AmusementClub/vs-nlm-cuda
  version = "4";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-nlm-cuda";
    rev = "refs/tags/v${version}";
    hash = "sha256-LXYLzZ8Gu3Qomus65eIAbP/p3eDdIBkCwnUHq5O/ia8=";
  };

  nativeBuildInputs = [
    cmake
    cudaPackages_12.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages_12.cuda_cudart
    cudaPackages_12.cuda_cccl
    vapoursynth
  ];

  cmakeFlags = [
    "-D CMAKE_CUDA_FLAGS='--use_fast_math'"
    "-D CMAKE_CUDA_ARCHITECTURES='50;61-real;70-virtual;75-real;86-real;89-real'"
    "-D VS_INCLUDE_DIR=${vapoursynth}/include/vapoursynth"
    "-D VCS_TAG=v${version}"
  ];

  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libvsnlm_cuda${cudaPackages_12.backendStdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth
  '';

  meta = with lib; {
    description = "Non-local means denoise filter in CUDA, drop-in replacement of the KNLMeansCL filter";
    homepage = "https://github.com/AmusementClub/vs-nlm-cuda";
    license = licenses.gpl3;
    badPlatforms = optionals (!cudaSupport) platforms.all;
    broken = !cudaSupport;
    platforms = platforms.all;
  };
}
