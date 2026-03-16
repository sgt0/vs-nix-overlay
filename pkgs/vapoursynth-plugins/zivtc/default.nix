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
    pname = "zivtc";
    version = "0-unstable-2026-03-16";

    src = fetchFromGitHub {
      owner = "arch1t3cht";
      repo = "vapoursynth-zivtc";
      rev = "b658c867cf71d35ea42a2e5d49ba9b5320c13e2c";
      hash = "sha256-vRtZjtdx8tDxJKrU+UxvfQvG83BpsUxcAGKo1Y1x+II=";
    };

    nativeBuildInputs = [
      zig_hook
    ];

    postConfigure = ''
      ln -s ${callPackage ./deps.nix {}} $ZIG_GLOBAL_CACHE_DIR/p
    '';

    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      ln -s $out/lib/libzivtc${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libzivtc${stdenv.hostPlatform.extensions.sharedLibrary}
    '';

    meta = with lib; {
      description = "Inverse telecine filter for VapourSynth written in Zig.";
      homepage = "https://github.com/arch1t3cht/vapoursynth-zivtc";
      license = licenses.x11;
      platforms = platforms.all;
    };
  }
