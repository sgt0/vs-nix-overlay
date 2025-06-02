{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_14,
  optimizeLevel ? "ReleaseFast",
}: let
  zig_hook = zig_0_14.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=${optimizeLevel}";
  };
in
  stdenv.mkDerivation rec {
    pname = "zsmooth";
    # renovate: datasource=github-releases depName=adworacz/zscene
    version = "0.1";

    src = fetchFromGitHub {
      owner = "adworacz";
      repo = "zscene";
      rev = "refs/tags/${version}";
      hash = "sha256-VFUJPe66hPNIEsMC/3Gql8g9jtIAAx0o9FWiBPPhBFM=";
    };

    nativeBuildInputs = [
      zig_hook
    ];

    postPatch = ''
      ln -s ${callPackage ./deps.nix {zig = zig_0_14;}} $ZIG_GLOBAL_CACHE_DIR/p
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
