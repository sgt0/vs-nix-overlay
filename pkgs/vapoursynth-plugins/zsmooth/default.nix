{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_12,
  optimizeLevel ? "ReleaseFast",
}:
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
    zig_0_12
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
    description = "Cross-platform smoothing functions written in Zig";
    homepage = "https://github.com/adworacz/zsmooth";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
