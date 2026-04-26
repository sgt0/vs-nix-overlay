{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libplacebo,
  vapoursynth,
  vulkan-headers,
}:
stdenv.mkDerivation rec {
  pname = "placebo";
  # renovate: datasource=github-releases depName=Lypheo/vs-placebo
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Lypheo";
    repo = "vs-placebo";
    rev = "refs/tags/${version}";
    hash = "sha256-t+Gw33dDeVMJvDT+1EnYvfRl07MHuYXx0YMitisWIr4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    libplacebo
    vapoursynth
    vulkan-headers
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "libplacebo-based debanding, scaling and color mapping plugin for VapourSynth";
    homepage = "https://github.com/Lypheo/vs-placebo";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
