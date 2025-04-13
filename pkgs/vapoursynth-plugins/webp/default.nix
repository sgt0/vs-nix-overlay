{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "webp";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-webp
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-webp";
    rev = "refs/tags/v${version}";
    hash = "sha256-tjp9z5tlwQ47j3C25F/OYnHuZyAxlTHEJ9sdZMIf6/c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Rk1GoPXGshZcllZLbvKX5J7EI7wd0bodGgNrGmuccdI=";

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
