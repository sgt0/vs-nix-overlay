{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  boost,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "eedi3m";
  # renovate: datasource=github-releases depName=HomeOfVapourSynthEvolution/VapourSynth-EEDI3 extractVersion=^r(?<version>.+)$
  version = "9";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI3";
    rev = "refs/tags/r${version}";
    hash = "sha256-/3elqMGarp1+T7K0wOIEbePsa80UUhMEwnYUudNnGxg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    vapoursynth
  ];

  postPatch = ''
    sed -i "/^incdir = /,/^)/c\incdir = include_directories('${vapoursynth}/include/vapoursynth')" meson.build
    substituteInPlace meson.build \
      --replace-fail "import('python').find_installation(pure: false)" "disabler()" \
      --replace-fail "py.get_install_dir() / 'vapoursynth/plugins'" "get_option('libdir') / 'vapoursynth'"
  '';

  mesonBuildType = "release";
  mesonFlags = [
    "-Db_lto=false"
  ];

  meta = with lib; {
    description = "An intra-field only deinterlacer";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = licenses.gpl2;
    platforms = platforms.x86_64;
  };
}
