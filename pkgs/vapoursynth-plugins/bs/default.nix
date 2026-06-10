{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  xxhash,
}:
stdenv.mkDerivation rec {
  pname = "bs";
  # renovate: datasource=github-releases depName=vapoursynth/bestsource extractVersion=^R(?<version>.+)$
  version = "18";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "bestsource";
    rev = "refs/tags/R${version}";
    hash = "sha256-tF0rJT1cH6p71RP4w0If9lP1ZVRIWKoIyxEg1/rscbg=";
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
    xxhash
  ];

  postPatch = ''
        substituteInPlace meson.build \
          --replace-fail \
            "incdir = include_directories(
        run_command(
            find_program('python', 'python3'),
            '-c',
            'import vapoursynth as vs; print(vs.get_include())',
            check: true,
        ).stdout().strip(),
        'AviSynthPlus/avs_core/include'
    )" \
            "deps += dependency('vapoursynth')
    incdir = include_directories(
        'AviSynthPlus/avs_core/include'
    )"
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
