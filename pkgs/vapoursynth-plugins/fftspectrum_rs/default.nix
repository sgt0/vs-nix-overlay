{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "fftspectrum_rs";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-fftspectrum-rs
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-fftspectrum-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-cx6W9BLyk9qO+4uuJQl3Yw68CkbKOScbkeGAPqKENt4=";
  };

  cargoHash = "sha256-jn8h4KUQN1lVyE3iiXFUIIJ4bbXJ7iNMCGKbwWlgwsg=";

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
