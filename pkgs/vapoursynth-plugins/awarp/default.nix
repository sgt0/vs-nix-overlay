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
  pname = "awarp";
  # renovate: datasource=github-releases depName=HolyWu/VapourSynth-AWarp extractVersion=^r(?<version>.+)$
  version = "2";

  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-AWarp";
    rev = "refs/tags/r${version}";
    hash = "sha256-np/mlWLVgfMqzyQojiVGkGg19Byp1r1ryP2241az3OI=";
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
      --replace-fail "vapoursynth_dep.get_variable('libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";
  mesonFlags = [
    "-Db_lto=false"
  ];

  meta = with lib; {
    description = "AWarp filter for VapourSynth";
    homepage = "https://github.com/HolyWu/VapourSynth-AWarp";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
