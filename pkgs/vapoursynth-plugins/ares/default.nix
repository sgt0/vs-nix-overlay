{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsamplerate,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "ares";
  # renovate: datasource=github-tags depName=ropagr/VapourSynth-AudioResample
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ropagr";
    repo = "VapourSynth-AudioResample";
    rev = "refs/tags/v${version}";
    hash = "sha256-MLKWl/1DqUypN6gSGY571AGSOQjUeS+skLOXRPgmGfI=";
  };

  patches = [
    ./deps.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libsamplerate
    vapoursynth
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vapoursynth
    cp AudioResample${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth

    runHook postInstall
  '';

  meta = with lib; {
    description = "Audio sample rate and sample type converter";
    homepage = "https://github.com/ropagr/VapourSynth-AudioResample";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
