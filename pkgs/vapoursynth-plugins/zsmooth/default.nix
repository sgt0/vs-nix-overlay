{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_12,
  optimizeLevel ? "ReleaseFast",
}: let
  zig_hook = zig_0_12.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=${optimizeLevel}";
  };
in
  stdenv.mkDerivation rec {
    pname = "zsmooth";
    # renovate: datasource=github-releases depName=adworacz/zsmooth
    version = "0.6";

    src = fetchFromGitHub {
      owner = "adworacz";
      repo = "zsmooth";
      rev = "refs/tags/${version}";
      hash = "sha256-26gGkMJ0J7jcU89HQ7nAadSNIV52EJy1uj6pn6jyUPg=";
    };

    nativeBuildInputs = [
      zig_hook
    ];

    postPatch = ''
      cp -a ${callPackage ./deps.nix {}}/. $ZIG_GLOBAL_CACHE_DIR/p
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
