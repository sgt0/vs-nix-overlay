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
    pname = "zscene";
    # renovate: datasource=github-releases depName=adworacz/zscene
    version = "0.3";

    src = fetchFromGitHub {
      owner = "adworacz";
      repo = "zscene";
      rev = "refs/tags/${version}";
      hash = "sha256-fcrMfGSdbTgNNTgVElNThmoPuCBmXyugCkQYJBaDcKI=";
    };

    nativeBuildInputs = [
      zig_hook
    ];

    postConfigure = ''
      ln -s ${callPackage ./deps.nix {}} $ZIG_GLOBAL_CACHE_DIR/p
    '';

    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      ln -s $out/lib/libzscene${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libzscene${stdenv.hostPlatform.extensions.sharedLibrary}
    '';

    meta = with lib; {
      description = "Scene change detection for Vapoursynth";
      homepage = "https://github.com/adworacz/zscene";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
