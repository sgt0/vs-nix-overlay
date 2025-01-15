{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ffmpeg,
  pkg-config,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "ffms2";
  # renovate: datasource=github-releases depName=FFMS/ffms2
  version = "5.0";

  src = fetchFromGitHub {
    owner = "FFMS";
    repo = "ffms2";
    rev = "refs/tags/${version}";
    hash = "sha256-Ildl8hbKSFGh4MUBK+k8uYMDrOZD9NSMdPAWIIaGy4E=";
  };

  env.NIX_CFLAGS_COMPILE = "-fPIC";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    zlib
  ];

  autoreconfPhase = ''
    mkdir src/config
  '';

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libffms2${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libffms2${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "An FFmpeg based source library and Avisynth/VapourSynth plugin for easy frame accurate access";
    homepage = "https://github.com/FFMS/ffms2";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "ffmsindex";
  };
}
