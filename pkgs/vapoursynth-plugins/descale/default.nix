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
  pname = "descale";
  version = "10-unstable-2024-01-19";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-descale";
    rev = "f84c408a414862e84543af9f589bed5b5e10ae3f";
    hash = "sha256-+VTBUIRupWzJnjuwLxryYLaC0Q3mUPLAy70l03lT8/o=";
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
      --replace-fail "vs.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "Undoes resizing";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-descale";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
