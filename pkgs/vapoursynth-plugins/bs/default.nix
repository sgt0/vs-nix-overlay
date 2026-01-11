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
  version = "16";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "bestsource";
    rev = "refs/tags/R${version}";
    hash = "sha256-t8dRP53hw68VElVV3og6WkNE75lmKx8llQVsfpg49+0=";
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

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_variable('libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "A super great audio/video source and FFmpeg wrapper";
    homepage = "https://github.com/vapoursynth/bestsource";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
