{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
}: let
  inherit (lib) optionals;
in
  stdenv.mkDerivation {
    pname = "raws";
    version = "0-unstable-2025-06-03";

    src = fetchFromGitHub {
      owner = "chikuzen";
      repo = "vsrawsource";
      rev = "9eb5f63d6ca7f96bcf7e5c565ebd96797764944f";
      hash = "sha256-xKnoXukH5Eh1YmV+7hl38reOy6En9u10VshB44WrMtg=";
    };

    strictDeps = true;

    nativeBuildInputs = [
      which
    ];

    makefile = "GNUmakefile";
    dontAddPrefix = true;
    configureFlags = optionals stdenv.cc.isClang ["--cc=${stdenv.cc.targetPrefix}clang" "--target-os=linux"];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/vapoursynth
      cp libvsrawsource${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth

      runHook postInstall
    '';

    meta = with lib; {
      description = "Raw-format file reader.";
      homepage = "https://github.com/chikuzen/vsrawsource";
      license = licenses.lgpl21;
      platforms = platforms.all;
      # configure script errors out on Darwin.
      badPlatforms = platforms.darwin;
    };
  }
