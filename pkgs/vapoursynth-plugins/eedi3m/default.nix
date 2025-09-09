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
  version = "6";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI3";
    rev = "refs/tags/r${version}";
    hash = "sha256-F6BxS653OeLr4XJE47xEWmhFgS4GkLqDP+Jv7oj66Go=";
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
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "An intra-field only deinterlacer";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = licenses.gpl2;
    platforms = platforms.x86_64;
  };
}
