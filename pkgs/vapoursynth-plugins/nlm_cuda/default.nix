{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cudaPackages_12,
  vapoursynth,
  config,
  cudaSupport ? config.cudaSupport,
}:
stdenv.mkDerivation rec {
  pname = "nlm_cuda";
  # renovate: datasource=github-releases depName=AmusementClub/vs-nlm-cuda
  version = "3";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-nlm-cuda";
    rev = "refs/tags/v${version}";
    hash = "sha256-HEZyiBsq61jfo0wmdATIRrybbivmD/YwH/Tdr70zzlc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    cudaPackages_12.cudatoolkit
    cudaPackages_12.cuda_cudart
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
    ln -s $out/lib/libvsnlm_cuda${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth
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
