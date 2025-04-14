{
  lib,
  stdenv,
  fetchFromGitHub,
  vapoursynth,
  pkg-config,
  which,
}: let
  inherit (lib) optionals;
in
  stdenv.mkDerivation {
    pname = "bilateral";
    version = "3-unstable-2025-01-19";

    src = fetchFromGitHub {
      owner = "HomeOfVapourSynthEvolution";
      repo = "VapourSynth-Bilateral";
      rev = "5c246c08914661fa2711eba5b7e8ca383bf0b717";
      hash = "sha256-whnL4U+kwv0m9jWkXIUYhnZ2BAn05IugfBZj9lGupyI=";
    };

    makefile = "GNUmakefile";

    nativeBuildInputs = [
      pkg-config
      which
    ];

    buildInputs = [
      vapoursynth
    ];

    dontAddPrefix = true;
    configureFlags =
      ["--install=$(out)/lib/vapoursynth"]
      ++ optionals stdenv.cc.isClang ["--cxx=${stdenv.cc.targetPrefix}clang++"];

    meta = with lib; {
      description = "Bilateral filter for VapourSynth.";
      homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bilateral";
      license = licenses.gpl3;
      platforms = platforms.all;
      broken = stdenv.cc.isClang; # configure script uses g++ arguments.
    };
  }
