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
  pname = "noise";
  # renovate: datasource=github-tags depName=wwww-wwww/vs-noise extractVersion=^r(?<version>.+)$
  version = "4";

  src = fetchFromGitHub {
    owner = "wwww-wwww";
    repo = "vs-noise";
    rev = "refs/tags/r${version}";
    hash = "sha256-pA5W9CxBgoqurMeIe8ekcOYNXr+Q/rFvWufu+7fLiAs=";
  };

  strictDeps = true;

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

  mesonFlags = [
    "-Db_lto=false"
  ];

  meta = with lib; {
    homepage = "https://github.com/wwww-wwww/vs-noise";
    description = "Generates film like noise or other effects (like rain) by adding random noise to a video clip";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
