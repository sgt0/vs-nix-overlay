{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libllvm,
  libxml2,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "akarin_jet";
  version = "0.96-unstable-2025-01-22";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "akarin-vapoursynth-plugin";
    rev = "62a5bae73a10ad344e6c02a228c03c5525854678";
    hash = "sha256-4XYNE3IhacTOveOPR722b509c17ho4tfbOYK7o7Ku1M=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    libllvm
    libxml2
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "Akarin's experimental VapourSynth plugin that provides an LLVM-based enhanced Expr (aka lexpr), and NVidia Deep Learning based super-resolution (DLISR) and video effect (DLVFX) filters";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/akarin-vapoursynth-plugin";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
