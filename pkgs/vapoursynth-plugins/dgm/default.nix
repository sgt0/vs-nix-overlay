{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "dgm";
  version = "1-unstable-2025-06-04";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-degrainmedian";
    rev = "0704888a65b2738a93bf57cb02e4c69cb9c6b2ff";
    hash = "sha256-owMab7ZUiHTGIsu/QvrI2i3sOtQ6xp63ViPYJk5Z9Ho=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libdegrainmedian${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libdegrainmedian${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "Spatio-temporal limited median denoiser";
    homepage = "https://github.com/dubhater/vapoursynth-degrainmedian";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
