{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "fftspectrum_rs";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-fftspectrum-rs
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-fftspectrum-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-tLY3EzP2cbu4eb+6JUyltX0STZwAagid/kejQcsrfqc=";
  };

  cargoHash = "sha256-HJ2hNcXRC6A2z353JsBsjtyAooJbuve1w5Us5QKaTc0=";

  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libfftspectrum_rs${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libfftspectrum_rs${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "A faster FFT spectrum VapourSynth plugin.";
    homepage = "https://github.com/sgt0/vapoursynth-fftspectrum-rs";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
