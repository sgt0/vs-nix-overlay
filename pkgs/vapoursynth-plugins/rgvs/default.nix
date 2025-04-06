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
  pname = "rgvs";
  version = "1-unstable-2025-04-06";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vs-removegrain";
    rev = "89ca38a6971e371bdce2778291393258daa5f03b";
    hash = "sha256-UcS8EjZGCX00Pt5pAxBTzCiveTKS5yeFT+bQgXKnJ+k=";
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
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "RemoveGrain is a spatial denoising filter with various filtering modes.";
    homepage = "https://github.com/vapoursynth/vs-removegrain";
    license = licenses.wtfpl;
    platforms = platforms.all;
  };
}
