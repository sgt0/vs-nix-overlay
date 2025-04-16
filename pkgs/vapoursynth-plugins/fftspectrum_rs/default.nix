{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "fftspectrum_rs";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-fftspectrum-rs
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-fftspectrum-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-6Rd3XCgf60DmEhiFqywd57RQstkXGI4BoGM8c7q+8fY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RbVoKHtp5Meq8vTNBPvaea5HmoarU3EVaQDoP2jsDRA=";

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
