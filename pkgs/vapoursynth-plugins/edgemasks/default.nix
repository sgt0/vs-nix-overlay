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
  version = "3.2";

  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-EdgeMasks";
    rev = "refs/tags/r${version}";
    hash = "sha256-WQAxAxKR4BbvL02HeGeelTU4k9XbC7kO3KgU2mb+5qg=";
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
    description = "EdgeMasks filter for VapourSynth";
    homepage = "https://github.com/HolyWu/VapourSynth-EdgeMasks";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
