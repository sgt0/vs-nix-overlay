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
  pname = "eedi2";
  # renovate: datasource=github-releases depName=HomeOfVapourSynthEvolution/VapourSynth-EEDI2 extractVersion=^r(?<version>.+)$
  version = "7.1";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI2";
    rev = "refs/tags/r${version}";
    hash = "sha256-Dt0rFwULpdZ83xKcwWd0NVQ4chgjtrJBIe0XTFazzoM=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "EEDI2";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI2";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
