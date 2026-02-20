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
    pname = "manipmv";
    # renovate: datasource=github-releases depName=Mikewando/manipulate-motion-vectors
    version = "1.2.2";

    src = fetchFromGitHub {
      owner = "Mikewando";
      repo = "manipulate-motion-vectors";
      rev = "refs/tags/${version}";
      hash = "sha256-HdYH/zgrZe8Sx67dx2eLqNydphrRWvQv7xOGrfKXoiI=";
    };

    nativeBuildInputs = [
      zig_hook
    ];

    postConfigure = ''
      ln -s ${callPackage ./deps.nix {}} $ZIG_GLOBAL_CACHE_DIR/p
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
