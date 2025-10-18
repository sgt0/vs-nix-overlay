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
stdenv.mkDerivation rec {
  pname = "sneedif";
  # renovate: datasource=github-releases depName=Jaded-Encoding-Thaumaturgy/vapoursynth-SNEEDIF extractVersion=^R(?<version>.+)$
  version = "3";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-SNEEDIF";
    rev = "refs/tags/R${version}";
    hash = "sha256-EaX4G6S/BN4g63YFiO/jc+Nx9K0SDiNS0I5td1MRip0=";
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
    license = licenses.wtfpl;
    platforms = platforms.all;
    broken = true; # Build fails with latest OpenCL.
  };
}
