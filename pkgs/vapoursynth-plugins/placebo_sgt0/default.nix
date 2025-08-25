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
  pname = "placebo_sgt0";
  # renovate: datasource=github-releases depName=sgt0/vs-placebo
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "sgt0";
    repo = "vs-placebo";
    rev = "refs/tags/v${version}";
    hash = "sha256-/gYz3VhbNoX4wEtfQ9xYootVrIm1peftKrCQQU+fFGw=";
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
    homepage = "https://github.com/sgt0/vs-placebo";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
