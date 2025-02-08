{
  lib,
  stdenv,
  fetchFromGitHub,
  zig, # Requires nightly.
  optimizeLevel ? "ReleaseFast",
}: let
  zig_hook = zig.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=${optimizeLevel}";
  };
in
  stdenv.mkDerivation rec {
    pname = "vszip";
    # renovate: datasource=github-releases depName=dnjulek/vapoursynth-zip extractVersion=^R(?<version>.+)$
    version = "5";

    src = fetchFromGitHub {
      owner = "dnjulek";
      repo = "vapoursynth-zip";
      rev = "refs/tags/R${version}";
      hash = "sha256-1mmM8LYcOGQQZyi13SdEl1pTFjKLB9IQUllcH1Dje/k=";
    };

    nativeBuildInputs = [
      zig_hook
    ];

    dontConfigure = true;

    preBuild = ''
      # Necessary for zig cache to work.
      export HOME=$TMPDIR
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/vapoursynth
      ln -s zig-out/lib/libvszip${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libvszip${stdenv.hostPlatform.extensions.sharedLibrary}
      runHook postInstall
    '';

    meta = with lib; {
      description = "VapourSynth Zig Image Process";
      homepage = "https://github.com/dnjulek/vapoursynth-zip";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
