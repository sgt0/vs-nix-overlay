{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cambi";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-cambi
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-cambi";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZUM6ImXrpAzYloVTM4euaEjmqCANNAQauFuZZmryjbI=";
  };

  cargoHash = "sha256-Ymk6VrFp3ncJekQ4zsEAvOr8r9AWEVVzVgdHdY07iF8=";

  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libcambi${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libcambi${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "Contrast Aware Multiscale Banding Index (CAMBI) as a VapourSynth plugin.";
    homepage = "https://github.com/sgt0/vapoursynth-cambi";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
