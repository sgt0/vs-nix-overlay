{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  xxHash,
}:
stdenv.mkDerivation rec {
  pname = "bs";
  # renovate: datasource=github-releases depName=vapoursynth/bestsource extractVersion=^R(?<version>.+)$
  version = "17";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "bestsource";
    rev = "refs/tags/R${version}";
    hash = "sha256-f3SSGLzW9GhKjDO3WelDOvg2aD+ka2cdvAcQCFX8rDk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    ffmpeg.dev
    vapoursynth
    xxHash
  ];

  mesonBuildType = "release";

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    mv $out/lib/python*/site-packages/vapoursynth/plugins/libbestsource${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/
    # Clean up the python site-packages tree left behind.
    rm -rf $out/lib/python*
  '';

  meta = with lib; {
    description = "A super great audio/video source and FFmpeg wrapper";
    homepage = "https://github.com/vapoursynth/bestsource";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
