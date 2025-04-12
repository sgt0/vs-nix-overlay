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
  pname = "tmedian";
  # renovate: datasource=github-releases depName=dubhater/vapoursynth-temporalmedian
  version = "1";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-temporalmedian";
    rev = "refs/tags/v${version}";
    hash = "sha256-UMYBA0kAGiNdcacV25O0pFgbt8bYbhS19u6edZfugYE=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    vapoursynth
  ];

  mesonBuildType = "release";
  mesonFlags = [
    "--libdir=${placeholder "out"}/lib/vapoursynth"
  ];

  meta = with lib; {
    description = "TemporalMedian is a temporal denoising filter. It replaces every pixel with the median of its temporal neighbourhood.";
    homepage = "https://github.com/dubhater/vapoursynth-temporalmedian";
    license = licenses.isc;
    platforms = platforms.all;
  };
}
