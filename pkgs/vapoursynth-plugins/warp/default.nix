{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "warp";
  # renovate: datasource=github-releases depName=dubhater/vapoursynth-awarpsharp2
  version = "4";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-awarpsharp2";
    rev = "refs/tags/v${version}";
    hash = "sha256-wB70gj/WJf+/vLteO05dawPPnvr/22FsDWHOYooF35g=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    vapoursynth
  ];

  mesonBuildType = "release";
  mesonFlags = [
    "--libdir=${placeholder "out"}/lib/vapoursynth"
  ];

  meta = with lib; {
    description = "Sharpens by warping";
    homepage = "https://github.com/dubhater/vapoursynth-awarpsharp2";
    license = licenses.isc;
    platforms = platforms.all;
  };
}
