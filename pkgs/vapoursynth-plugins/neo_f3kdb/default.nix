{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  tbb,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "neo_f3kdb";
  # renovate: datasource=github-tags depName=HomeOfAviSynthPlusEvolution/neo_f3kdb extractVersion=^r(?<version>.+)$
  version = "11";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "neo_f3kdb";
    rev = "refs/tags/r${version}";
    hash = "sha256-SH8m+homdsPMGgdK4vIu3QiDGHn/AFNZ0B54PCZoA2E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
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
    platforms = platforms.x86;
  };
}
