{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "webp";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-webp
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-webp";
    rev = "refs/tags/v${version}";
    hash = "sha256-zA2m6iRQN4Q0loCY3v5weQfFL8oB8DUtdxNdEZ64Vz8=";
  };

  cargoHash = "sha256-KpH1lWEUFP3c7JUuTqUT7yzTfZ6Iej56vhSBCCc/fB0=";

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
