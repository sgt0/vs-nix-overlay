{
  lib,
  stdenv,
  fetchFromGitHub,
  zig, # Requires nightly.
  optimizeLevel ? "ReleaseFast",
}:
stdenv.mkDerivation rec {
  pname = "vszip";
  # renovate: datasource=github-releases depName=dnjulek/vapoursynth-zip extractVersion=^R(?<version>.+)$
  version = "3";

  src = fetchFromGitHub {
    owner = "dnjulek";
    repo = "vapoursynth-zip";
    rev = "refs/tags/R${version}";
    hash = "sha256-YwC78Yw4r3TJg9CKgVuNlF7/5tratnoKMr9Rgfz/60k=";
  };

  nativeBuildInputs = [
    zig
  ];

  dontConfigure = true;

  preBuild = ''
    # Necessary for zig cache to work.
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Doptimize=${optimizeLevel} --prefix $out/vapoursynth install
    runHook postInstall
  '';

  meta = with lib; {
    description = "VapourSynth Zig Image Process";
    homepage = "https://github.com/dnjulek/vapoursynth-zip";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
