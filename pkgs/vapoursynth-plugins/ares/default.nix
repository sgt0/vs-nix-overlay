{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  soxr,
  vapoursynth,
  darwinMinVersionHook,
}:
stdenv.mkDerivation rec {
  pname = "ares";
  # renovate: datasource=github-tags depName=ropagr/VapourSynth-AudioResample
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ropagr";
    repo = "VapourSynth-AudioResample";
    rev = "refs/tags/v${version}";
    hash = "sha256-oUvxzW9okrX7xt2eo3lLb/OmKnwWRRf7fsdxqPvM5Mc=";
  };

  patches = [
    ./deps.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
      soxr
      vapoursynth
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (darwinMinVersionHook "13.3")
    ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "-static" ""
  '';

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
