{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "fh";
  # renovate: datasource=github-releases depName=dubhater/vapoursynth-fieldhint
  version = "3";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-fieldhint";
    rev = "refs/tags/v${version}";
    hash = "sha256-c0/59NQDINM1WnkcUMB6ItxgRA+OV5dEn6BxFG7UQmg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libfieldhint${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libfieldhint${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "FieldHint Plugin";
    homepage = "https://github.com/dubhater/vapoursynth-fieldhint";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
