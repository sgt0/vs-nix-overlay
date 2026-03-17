{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cambi";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-cambi
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-cambi";
    rev = "refs/tags/v${version}";
    hash = "sha256-om4UfqTfMi09yWKYtp/4msScTmbg9u3rcJ/ikdyIAqM=";
  };

  cargoHash = "sha256-WmdA87EyGNiI71kwONSCgfODOLo7bVCSwTjCSzqRaLI=";

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
