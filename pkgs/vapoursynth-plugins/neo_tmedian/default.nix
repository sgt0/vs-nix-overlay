{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "neo_tmedian";
  # renovate: datasource=github-tags depName=HomeOfAviSynthPlusEvolution/neo_TMedian extractVersion=^r(?<version>.+)$
  version = "2";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "neo_TMedian";
    rev = "refs/tags/r${version}";
    hash = "sha256-S1te9IcGiTf6FTFDrbtK4cZDuGk14nSltJaeNJ9b3LU=";
  };

  patches = [
    ./no-git.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vapoursynth
    cp libneo-tmedian${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth

    runHook postInstall
  '';

  meta = with lib; {
    description = "Neo Temporal Median is a temporal denoising filter. It replaces every pixel with the median of its temporal neighbourhood.";
    homepage = "https://github.com/HomeOfAviSynthPlusEvolution/neo_TMedian";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
