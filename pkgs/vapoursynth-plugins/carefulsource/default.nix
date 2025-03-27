{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  lcms,
  libjpeg,
  libpng,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "carefulsource";
  version = "4-unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "wwww-wwww";
    repo = "carefulsource";
    rev = "fd6ca51f1a974901fddd82e1c6909efd4538df7a";
    hash = "sha256-yvnyOPTdKNTqOIoMQxbPydF1RJSOha47QZu/qAobBxY=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    lcms
    libjpeg
    libpng
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    homepage = "https://github.com/wwww-wwww/carefulsource";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
