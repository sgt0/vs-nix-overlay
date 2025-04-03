{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "descale";
  version = "11";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-descale";
    rev = "refs/tags/r${version}";
    hash = "sha256-qCFMKO0NraxTRF+BQY3N2Vf6kakgLtNEZ8mU5pTTynM=";
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
