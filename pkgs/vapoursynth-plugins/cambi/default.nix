{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cambi";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-cambi
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-cambi";
    rev = "refs/tags/v${version}";
    hash = "sha256-n6RE1Kz/4P+vu6xRhUYtHS+n0C1H9saguNkeMUa1WhI=";
  };

  cargoHash = "sha256-XWXeNVFr3JDHiETnR7jP/S8bYNUPEAqTOOwPxC2EWOs=";

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
