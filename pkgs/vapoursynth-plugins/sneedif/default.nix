{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  boost,
  opencl-headers,
  ocl-icd,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "sneedif";
  version = "2-unstable-2025-06-03";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-SNEEDIF";
    rev = "55cbf2c35721ba5c228c0b1b906f97f45459a3b7";
    hash = "sha256-kBcRbE+18AI8MbsGjYBRR1i1PNmwiZanZhvlRX7HZ3g=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    boost
    opencl-headers
    ocl-icd
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "dependency('boost', modules : ['filesystem'], static : true)" "dependency('boost', modules : ['filesystem'], static : false)"
  '';

  mesonBuildType = "release";
  mesonFlags = ["--libdir=${placeholder "out"}/lib/vapoursynth"];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vapoursynth
    install -D libsneedif${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libsneedif${stdenv.hostPlatform.extensions.sharedLibrary}
    install -D ../asset/nnedi3_weights.bin $out/lib/vapoursynth/nnedi3_weights.bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Setsugen No Ensemble of Edge Directed Interpolation Functions";
    homepage = "hhttps://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-SNEEDIF";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
