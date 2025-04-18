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
  pname = "fpng";
  # renovate: datasource=github-releases depName=Mikewando/vsfpng
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Mikewando";
    repo = "vsfpng";
    rev = "refs/tags/${version}";
    hash = "sha256-OteiAug0g6trH24Xj+wAPRVCJYDjCt9YB31mWN1Ep3Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    description = "fpng for VapourSynth";
    homepage = "https://github.com/Mikewando/vsfpng";
    license = licenses.lgpl21;
    platforms = platforms.all;
    broken = stdenv.cc.isClang; # ../src/p2p_api.cpp:56:2: warning: missing field 'is_nv' initializer [-Wmissing-field-initializers]
  };
}
