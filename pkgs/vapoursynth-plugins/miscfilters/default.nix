{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "miscfilters";
  version = "2-unstable-2024-01-03";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vs-miscfilters-obsolete";
    rev = "07e0589a381f7deb3bf533bb459a94482bccc5c7";
    hash = "sha256-WEhpBTNEamNfrNXZxtpTGsOclPMRu+yBzNJmDnU0wzQ=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "Miscellaneous Filters is a random collection of filters that mostly are useful for Avisynth compatibility.";
    homepage = "https://github.com/vapoursynth/vs-miscfilters-obsolete";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
