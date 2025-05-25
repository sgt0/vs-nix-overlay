{
  lib,
  stdenv,
  fetchFromGitHub,
  vapoursynth,
  pkg-config,
  which,
  fftwSinglePrec,
}: let
  inherit (lib) optionals;
in
  stdenv.mkDerivation rec {
    pname = "depan";
    # renovate: datasource=github-releases depName=Vapoursynth-Plugins-Gitify/DePan extractVersion=^r(?<version>.+)$
    version = "1";

    src = fetchFromGitHub {
      owner = "Vapoursynth-Plugins-Gitify";
      repo = "DePan";
      rev = "refs/tags/r${version}";
      hash = "sha256-yXmT0ZppBZcOTsryYSyF5exRiwOwd5+WGaejL2w0MQ0=";
    };

    makefile = "GNUmakefile";

    preConfigure = "chmod +x configure";
    dontAddPrefix = true;
    configureFlags =
      ["--install=$(out)/lib/vapoursynth"]
      ++ optionals stdenv.cc.isClang ["--cxx=${stdenv.cc.targetPrefix}clang++"];

    nativeBuildInputs = [
      pkg-config
      which
    ];

    buildInputs = [
      fftwSinglePrec
      vapoursynth
    ];

    meta = with lib; {
      description = "DePan & DePanEstimate";
      homepage = "https://github.com/Vapoursynth-Plugins-Gitify/DePan";
      license = licenses.gpl2;
      platforms = platforms.all;
      broken = stdenv.cc.isClang; # configure script uses g++ arguments.
    };
  }
