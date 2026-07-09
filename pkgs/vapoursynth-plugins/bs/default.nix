{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  meson,
  ninja,
  pkg-config,
  python3,
  vapoursynth,
  xxhash,
}: let
  libp2p = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = "libp2p";
    rev = "869fa993041f9f3af7d9ac8b10158920c6ddce66";
    hash = "sha256-84mCTO8MFWAcQ5WVC5W5w1a7caBQnMZ3pfRF6PbuSZg=";
  };
  avisynthplus = fetchFromGitHub {
    owner = "AviSynth";
    repo = "AviSynthPlus";
    rev = "v3.7.5";
    hash = "sha256-RkEZWsAKZABtl+SbRLCjMqyQoi9ainbaI9hWlpO6Fwo=";
  };
in
  stdenv.mkDerivation rec {
    pname = "bs";
    # renovate: datasource=github-releases depName=vapoursynth/bestsource extractVersion=^R(?<version>.+)$
    version = "19";

    outputs = [
      "out"
      "dev"
    ];

    src = fetchFromGitHub {
      owner = "vapoursynth";
      repo = "bestsource";
      rev = "refs/tags/R${version}";
      hash = "sha256-qkbh6hKq2Q93Y54ZZe9AG/FhuLt5CEX1iYG3wkXDx78=";
    };

    nativeBuildInputs = [
      pkg-config
      meson
      ninja
      python3
    ];

    buildInputs = [
      ffmpeg.dev
      vapoursynth
      xxhash
    ];

    postPatch = ''
      cp -r --no-preserve=mode ${libp2p} subprojects/libp2p
      cp -r --no-preserve=mode ${avisynthplus} subprojects/avisynthplus
      cp subprojects/packagefiles/libp2p/meson.build subprojects/libp2p/
      cp subprojects/packagefiles/avisynthplus/meson.build subprojects/avisynthplus/

      substituteInPlace meson.build \
        --replace-fail \
          "incdir += include_directories(
              run_command(py, '-c', 'import vapoursynth as vs; print(vs.get_include())', check: true).stdout().strip(),
          )" \
          "deps += dependency('vapoursynth')"
    '';

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
