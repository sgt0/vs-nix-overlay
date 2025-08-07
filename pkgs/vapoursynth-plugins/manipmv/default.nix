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
    pname = "manipmv";
    # renovate: datasource=github-releases depName=Mikewando/manipulate-motion-vectors
    version = "1.2.1";

    src = fetchFromGitHub {
      owner = "Mikewando";
      repo = "manipulate-motion-vectors";
      rev = "refs/tags/${version}";
      hash = "sha256-8i2G3TD/+MRsfgPELP5hBo++KBbYksPoKESi4p7R98w=";
    };

    nativeBuildInputs = [
      zig_hook
    ];

    postPatch = ''
      ln -s ${callPackage ./deps.nix {zig = zig_0_14;}} $ZIG_GLOBAL_CACHE_DIR/p
    '';

    postInstall = ''
      mkdir -p $out/lib/vapoursynth
      ln -s $out/lib/libmanipmv${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libmanipmv${stdenv.hostPlatform.extensions.sharedLibrary}
    '';

    meta = with lib; {
      description = "A vapoursynth plugin to do potentially useful things with motion vectors that have already been generated.";
      homepage = "https://github.com/Mikewando/manipulate-motion-vectors";
      license = licenses.lgpl21;
      platforms = platforms.all;
    };
  }
