{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
  xvidcore,
}:
stdenv.mkDerivation rec {
  pname = "scxvid";
  # renovate: datasource=github-releases depName=dubhater/vapoursynth-scxvid
  version = "1";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-scxvid";
    rev = "refs/tags/v${version}";
    hash = "sha256-DixLg8Fup6ikE9a9pyFO2hynhWl6ZV8LH92Rp9egTo0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    xvidcore
  ];

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libscxvid${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libscxvid${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "Scene change detection plugin for VapourSynth, using xvid";
    homepage = "https://github.com/dubhater/vapoursynth-scxvid";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
