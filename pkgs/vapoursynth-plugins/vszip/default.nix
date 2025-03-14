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
  stdenv.mkDerivation {
    pname = "vszip";
    version = "5-unstable-2025-03-14";

    src = fetchFromGitHub {
      owner = "dnjulek";
      repo = "vapoursynth-zip";
      rev = "381eee51e0a65ac5e33fbba47d0e53e2d6155f0a";
      hash = "sha256-sCHiXGRmEvMWcCzWZMQmUl+REhpN5eLITNsB0OqOrsg=";
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
