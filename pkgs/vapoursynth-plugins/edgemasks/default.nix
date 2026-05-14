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
  pname = "edgemasks";
  # renovate: datasource=github-releases depName=HolyWu/VapourSynth-EdgeMasks extractVersion=^r(?<version>.+)$
  version = "4.1";

  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-EdgeMasks";
    rev = "refs/tags/r${version}";
    hash = "sha256-6Ub6f8eLS2FdFKdxZPtTe59I9H/TYHvE+0w/b6e9ON4=";
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
    description = "EdgeMasks filter for VapourSynth";
    homepage = "https://github.com/HolyWu/VapourSynth-EdgeMasks";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
