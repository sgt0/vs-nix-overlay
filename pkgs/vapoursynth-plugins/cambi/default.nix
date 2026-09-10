{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cambi";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-cambi
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-cambi";
    rev = "refs/tags/v${version}";
    hash = "sha256-OFrS9wUU/J89emBfCwM7BolPQgVEO78oKmDCsNLWLGk=";
  };

  cargoHash = "sha256-4Rd3M72sMtIgAc1HlTFBfNhJm9K5nuIWyCr3MhE8Y70=";

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
