{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  fftwSinglePrec,
  nasm,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "mv";
  version = "24-unstable-2025-04-12";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-mvtools";
    rev = "e516e90f9618a20c2dc06be05935d2abbb5f691b";
    hash = "sha256-u00mcPLiR0c2ukqUCrQLhjyiKkRdM+6AckTsE5rtU7g=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    nasm
    ninja
  ];

  buildInputs = [
    fftwSinglePrec
    vapoursynth
  ];

  mesonBuildType = "release";
  mesonFlags = [
    "-Db_lto=false"
    "--libdir=${placeholder "out"}/lib/vapoursynth"
  ];

  meta = with lib; {
    description = "MVTools port";
    homepage = "https://github.com/dubhater/vapoursynth-mvtools";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
