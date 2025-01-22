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
  pname = "tivtc";
  version = "2-unstable-2025-01-22";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-tivtc";
    rev = "7abd4a3bc1fdc625400bc4f84ba618ee6a8da53a";
    hash = "sha256-WIJO6zgxmvfPgMP9Z53+L6PFW/v2EwJC61zYebBOrCk=";
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
    description = "Field matching and decimation";
    homepage = "https://github.com/dubhater/vapoursynth-tivtc";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
