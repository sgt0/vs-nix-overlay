{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig,
  optimizeLevel ? "ReleaseFast",
}: let
  zig_hook = zig.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=${optimizeLevel}";
  };
in
  stdenv.mkDerivation rec {
    pname = "vszip";
    # renovate: datasource=github-releases depName=dnjulek/vapoursynth-zip extractVersion=^R(?<version>.+)$
    version = "9";

    src = fetchFromGitHub {
      owner = "dnjulek";
      repo = "vapoursynth-zip";
      rev = "refs/tags/R${version}";
      hash = "sha256-aru8HlfL8Aq/kM61omB+PdSTFin75mE9LHeqIthSXT8=";
    };

    nativeBuildInputs = [
      zig_hook
    ];

    postPatch = ''
      cp -a ${callPackage ./deps.nix {}}/. $ZIG_GLOBAL_CACHE_DIR/p
    '';

    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      ln -s $out/lib/libvszip${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libvszip${stdenv.hostPlatform.extensions.sharedLibrary}
    '';

    meta = with lib; {
      description = "VapourSynth Zig Image Process";
      homepage = "https://github.com/dnjulek/vapoursynth-zip";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
