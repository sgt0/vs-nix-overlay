{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  llvmPackages_15,
  libxml2,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "akarin";
  version = "0.96-unstable-2025-01-22";

  src = fetchFromGitHub {
    owner = "AkarinVS";
    repo = "vapoursynth-plugin";
    rev = "8b7ff6dcc85bc9935789c799e63f1388dfbd1bd4";
    hash = "sha256-azo5iD1gvGaMkIdRV7ZX2KQxEJ61B1j7mrhVdtrfarE=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    llvmPackages_15.libllvm
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
    homepage = "https://github.com/AkarinVS/vapoursynth-plugin";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
