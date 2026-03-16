{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "webp";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-webp
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-webp";
    rev = "refs/tags/v${version}";
    hash = "sha256-UhQIX5PXpFo2Erld5+PXW/GQC+6KaSos/PCrp8fasWg=";
  };

  cargoHash = "sha256-oeHmyLv0t566Y9dziPfUTm74mTYy1e491V8cNwQXzv0=";

  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libwebp${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libwebp${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "WebP encoding as a VapourSynth plugin.";
    homepage = "https://github.com/sgt0/vapoursynth-webp";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
