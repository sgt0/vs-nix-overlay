{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "hist";
  version = "2-unstable-2025-06-16";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-histogram";
    rev = "c4861d63d496fa0eb873a6f949937be8c9c1dc13";
    hash = "sha256-0oSIHnzFfnuKMZA6jPSeyV2ekRlbJOnTyxzi2B9DF0k=";
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
    ln -s $out/lib/libhistogram${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libhistogram${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "VapourSynth Histogram Plugin";
    homepage = "https://github.com/dubhater/vapoursynth-histogram";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
