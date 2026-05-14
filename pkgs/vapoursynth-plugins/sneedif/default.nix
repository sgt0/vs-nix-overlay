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
  version = "4.3";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-SNEEDIF";
    rev = "refs/tags/R${version}";
    hash = "sha256-HyrZkxa6nyV4f6lNTl2//eaXTLwxj/q/bljRR5WGTSk=";
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
      --replace-fail \
        "py = import('python').find_installation(pure: false)

r = run_command(py, '-c', 'import vapoursynth as vs; print(vs.get_include())', check: true)
inc_vs = include_directories(r.stdout().strip())" \
        "vapoursynth_dep = dependency('vapoursynth')" \
      --replace-fail \
        "deps = [boost_dep, opencl_dep]" \
        "deps = [boost_dep, opencl_dep, vapoursynth_dep]" \
      --replace-fail \
        "include_directories: inc_vs," \
        ""
  '';

  mesonBuildType = "release";
  mesonFlags = ["--libdir=${placeholder "out"}/lib/vapoursynth"];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vapoursynth $out/share/SNEEDIF
    install -D libsneedif${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libsneedif${stdenv.hostPlatform.extensions.sharedLibrary}
    install -D ../asset/nnedi3_weights.bin $out/share/SNEEDIF/nnedi3_weights.bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Setsugen No Ensemble of Edge Directed Interpolation Functions";
    homepage = "hhttps://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-SNEEDIF";
    license = licenses.wtfpl;
    platforms = platforms.x86;
  };
}
