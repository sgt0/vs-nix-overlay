{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "webp";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-webp
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-webp";
    rev = "refs/tags/v${version}";
    hash = "sha256-zAYHj8F4A5r0BfATa8oEsouj9mBe8WIAuXxCdH1KXcU=";
  };

  cargoHash = "sha256-qbVeztwIvpurb5+us5rrlAfpFkr6Zrlq8NYI+hjjDA0=";

  postInstall = ''
    mkdir $out/lib/vapoursynth
    mv $out/lib/libwebp.so $out/lib/vapoursynth/libwebp.so
  '';

  meta = with lib; {
    description = "WebP encoding as a VapourSynth plugin.";
    homepage = "https://github.com/sgt0/vapoursynth-webp";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
