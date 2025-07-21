{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "fftspectrum_rs";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-fftspectrum-rs
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-fftspectrum-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-I4F5CzHYnsqxtQzWtY4meBArmevpFFVUNiSOUWBazhM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DXalTud/+7sQ8iQ9F6jaccN+Qse5cSxOkGaUxr+uzYE=";

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
