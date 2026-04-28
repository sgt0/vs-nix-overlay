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
  # renovate: datasource=github-tags depName=HomeOfAviSynthPlusEvolution/neo_f3kdb extractVersion=^r(?<version>.+)$
  version = "10";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "neo_f3kdb";
    rev = "refs/tags/r${version}";
    hash = "sha256-9aEJkK/5ObHJtPqf6CyB0JuqZbXvjZQArfgs+ChAt20=";
  };

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
    platforms = platforms.x86;
  };
}
