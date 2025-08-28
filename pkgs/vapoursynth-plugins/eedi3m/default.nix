{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  withOpenCL ? false,
  boost,
  ocl-icd,
  opencl-headers,
}:
stdenv.mkDerivation {
  pname = "eedi3m";
  version = "4-unstable-2025-02-13";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI3";
    rev = "d11bdb37c7a7118cd095b53d9f8fbbac02a06ac0";
    hash = "sha256-MIUf6sOnJ2uqGw3ixEHy1ijzlLFkQauwtm1vfgmYmcg=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs =
    [
      boost
      vapoursynth
    ]
    ++ lib.optional withOpenCL [
      ocl-icd
      opencl-headers
    ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";
  mesonFlags = [
    (lib.mesonBool "opencl" withOpenCL)
  ];

  meta = with lib; {
    description = "An intra-field only deinterlacer";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = licenses.gpl2;
    platforms = platforms.x86_64;
  };
}
