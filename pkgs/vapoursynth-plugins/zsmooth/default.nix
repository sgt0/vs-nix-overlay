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
    pname = "zsmooth";
    # renovate: datasource=github-releases depName=adworacz/zsmooth
    version = "0.14";

    src = fetchFromGitHub {
      owner = "adworacz";
      repo = "zsmooth";
      rev = "refs/tags/${version}";
      hash = "sha256-nUctTj0hZvW264QcEUz4KlD9y0X6NH/BpAGcSjaN5fY=";
    };

    nativeBuildInputs = [
      zig_hook
    ];

    postPatch = ''
      ln -s ${callPackage ./deps.nix {zig = zig;}} $ZIG_GLOBAL_CACHE_DIR/p
    '';

    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      ln -s $out/lib/libzsmooth${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libzsmooth${stdenv.hostPlatform.extensions.sharedLibrary}
    '';

    meta = with lib; {
      description = "Cross-platform smoothing functions written in Zig";
      homepage = "https://github.com/adworacz/zsmooth";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
