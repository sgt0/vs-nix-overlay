{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  tbb,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "neo_f3kdb";
  version = "9-unstable-2025-04-19";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "neo_f3kdb";
    rev = "ad9fa1a11412ab46199d3b8e7cc2e5a89f1d5d1a";
    hash = "sha256-bLBSO3x51A9RR7d21Z8S0vL4ZDALKO0epI+3WlTneKU=";
  };

  patches = [
    ./no-git.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    tbb
    vapoursynth
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vapoursynth
    cp libneo-f3kdb${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth

    runHook postInstall
  '';

  meta = with lib; {
    description = "Basically like f3kdb but with legacy format support removed (in Avisynth) and with new sample modes.";
    homepage = "https://github.com/HomeOfAviSynthPlusEvolution/neo_f3kdb";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
