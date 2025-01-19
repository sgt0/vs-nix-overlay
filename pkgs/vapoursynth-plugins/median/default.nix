{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "median";
  # renovate: datasource=github-releases depName=dubhater/vapoursynth-median
  version = "4";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-median";
    rev = "refs/tags/v${version}";
    hash = "sha256-23rNaTanNgD1ClKSbEfRzLRbLekubY4TnL28ecKLoJs=";
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
    description = "Median generates a pixel-by-pixel median of several clips";
    homepage = "https://github.com/dubhater/vapoursynth-median";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
