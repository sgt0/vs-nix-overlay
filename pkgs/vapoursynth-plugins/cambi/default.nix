{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cambi";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-cambi
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-cambi";
    rev = "refs/tags/v${version}";
    hash = "sha256-f30uqW7QYOw6p+HZk23SVvGBhG1cohHl0dy5HZ3Azwk=";
  };

  cargoHash = "sha256-jRuQkjGrQQfJZ56ca9a5sjvexeDNArLDNyeyE7qAROs=";

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
