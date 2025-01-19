{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "colorbars";
  version = "4-unstable-2024-01-19";

  src = fetchFromGitHub {
    owner = "ifb";
    repo = "vapoursynth-colorbars";
    rev = "97a263b918fc8ac503ecceb5077d1d8fd846d3db";
    hash = "sha256-pVQUJbNwy4dIrUHrTyTuPGxA2wdtl4KheUzSLPEw8aw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  configureFlags = ["--libdir=$(out)/lib/vapoursynth"];

  meta = with lib; {
    description = "SMPTE RP 219-2:2016 and ITU-R BT.2111 color bar generator for VapourSynth.";
    homepage = "https://github.com/ifb/vapoursynth-colorbars";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
