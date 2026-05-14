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
  version = "3.1";

  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-AWarp";
    rev = "refs/tags/r${version}";
    hash = "sha256-daFgCAj1m/HGpIG1vqsEEE7eGuGBRdiQiC5gHLJWTfE=";
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
    description = "AWarp filter for VapourSynth";
    homepage = "https://github.com/HolyWu/VapourSynth-AWarp";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
