{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  fftwSinglePrec,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "dfttest";
  version = "7-unstable-2025-04-12";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-DFTTest";
    rev = "bc5e0186a7f309556f20a8e9502f2238e39179b8";
    hash = "sha256-HGk9yrs6T3LAP0I5GPt9b4LwldXtQDG277ffX6xMr/4=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    fftwSinglePrec
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "2D/3D frequency domain denoiser.";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DFTTest";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
