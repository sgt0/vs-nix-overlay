{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "webp";
  # renovate: datasource=github-releases depName=sgt0/vapoursynth-webp
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vapoursynth-webp";
    rev = "refs/tags/v${version}";
    hash = "sha256-Jx7/RBmyOYrxNpMBBBB0hlpFD4JCSCPMdG9uoymyjso=";
  };

  cargoHash = "sha256-rlnAD68LuwoRjGedYFS8lEi/9YKvvPB4mP+9X3XZlyc=";

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
