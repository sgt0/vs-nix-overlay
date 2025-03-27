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
  pname = "retinex";
  version = "4-unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-Retinex";
    rev = "6bfbdd429159c85075dc4b08e0ac4e706470916b";
    hash = "sha256-4LnVyW3m91PHE5L1qYT+O23bJpqxggpZ+kp0NLQzvWw=";
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

  meta = with lib; {
    description = "Dynamic range compression";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Retinex";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
