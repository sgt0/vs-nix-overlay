{
  lib,
  stdenv,
  fetchFromGitHub,
  zig, # Requires nightly.
  optimizeLevel ? "ReleaseFast",
}:
stdenv.mkDerivation rec {
  pname = "manipmv";
  # renovate: datasource=github-releases depName=Mikewando/manipulate-motion-vectors
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Mikewando";
    repo = "manipulate-motion-vectors";
    rev = "refs/tags/${version}";
    hash = "sha256-XxYf/F2J3mcaRAKltlXjwHhTt4+b5zfjGXUw26cfEIw=";
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
    description = "A vapoursynth plugin to do potentially useful things with motion vectors that have already been generated.";
    homepage = "https://github.com/Mikewando/manipulate-motion-vectors";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
