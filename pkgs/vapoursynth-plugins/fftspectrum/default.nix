{
  lib,
  stdenv,
  fetchFromGitHub,
  fftwSinglePrec,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "fftspectrum";
  version = "1-unstable-2024-01-03";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Beatrice-Raws";
    repo = "FFTSpectrum";
    rev = "6326b2e87ad577573fbe007d8f82d5fbe63b3c11";
    hash = "sha256-CJuNgfEr5jJgp84XoO71WdP1Ln7QUOH0Xq3YewCnTfI=";
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

  CFLAGS = "-march=x86-64-v2";
  mesonBuildType = "release";

  meta = with lib; {
    description = "A VapourSynth filter that displays the FFT frequency spectrum of a given clip.";
    homepage = "https://github.com/Beatrice-Raws/FFTSpectrum";
    license = licenses.gpl2;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
