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
  version = "3.1";

  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-EdgeMasks";
    rev = "refs/tags/r${version}";
    hash = "sha256-mA77BJLT7oaPhuoI3ZVvGZmGjVkBZOmpWWpwd5hPY9Q=";
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
      --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";
  mesonFlags = [
    "-Db_lto=false"
  ];

  meta = with lib; {
    description = "EdgeMasks filter for VapourSynth";
    homepage = "https://github.com/HolyWu/VapourSynth-EdgeMasks";
    license = licenses.mit;
    platforms = platforms.x86;
  };
}
