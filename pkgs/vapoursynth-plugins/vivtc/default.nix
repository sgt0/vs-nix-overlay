{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "vivtc";
  version = "1-unstable-2025-01-22";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vivtc";
    rev = "4ac661d78eaf8b5ab7c5dd2d05c81234fe9aaca8";
    hash = "sha256-7E7KjQb6i3GdbzUTpQP+wEtIX9+5rRF8YiN3FsrUF/E=";
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
    description = "VIVTC is a set of filters that can be used for inverse telecine.";
    homepage = "https://github.com/vapoursynth/vivtc";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
