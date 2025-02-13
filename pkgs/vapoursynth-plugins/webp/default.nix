{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "webp";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-webp
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-webp";
    rev = "refs/tags/v${version}";
    hash = "sha256-UBb29G2iEAtDw6OmLP/ZuxDLg2ciaLkESDAhJsjfPfk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-60zKMF5eSPjuXaW8EuN+wuRnCkljjDZ0r+wheK9jlug=";

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
