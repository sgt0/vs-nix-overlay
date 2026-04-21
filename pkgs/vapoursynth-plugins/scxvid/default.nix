{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  xvidcore,
}:
stdenv.mkDerivation rec {
  pname = "scxvid";
  # renovate: datasource=github-releases depName=dubhater/vapoursynth-scxvid
  version = "3";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-scxvid";
    rev = "refs/tags/v${version}";
    hash = "sha256-WgoIF7ni2j6wNCutysV18B693OapzniZoy94iyZR3uA=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    vapoursynth
    xvidcore
  ];

  patches = [./use-pkg-config.patch];

  mesonBuildType = "release";

  meta = with lib; {
    description = "Scene change detection plugin for VapourSynth, using xvid";
    homepage = "https://github.com/dubhater/vapoursynth-scxvid";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
