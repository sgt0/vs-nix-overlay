{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "fftspectrum_rs";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-fftspectrum-rs
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-fftspectrum-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-6ojMejfa5qugtdCDa2TbBih+4ip1o0vge2JhGn9lb9U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-oskAXjbCOnESJvpU9DuVxyICpXjYSddtsHAImuDoxbM=";

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
