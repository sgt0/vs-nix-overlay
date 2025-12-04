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
  pname = "dmetrics";
  version = "1-unstable-2025-12-04";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "dmetrics";
    rev = "adec0f3cdf76030e71686cea744187b66e22ea0d";
    hash = "sha256-UcqOdTaMzJQBi0buVa5ChSU10dUOjnAAcdS5CHBLPL8=";
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

  meta = with lib; {
    description = "Attaches the match metrics calculated by Telecide (decomb package) to frames as properties";
    homepage = "https://github.com/vapoursynth/dmetrics";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
