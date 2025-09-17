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
stdenv.mkDerivation rec {
  pname = "akarin_jet";
  # renovate: datasource=github-releases depName=Jaded-Encoding-Thaumaturgy/akarin-vapoursynth-plugin
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "akarin-vapoursynth-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-VeG2rMIuS//Ov0gbLJUFXxuOIvqoUV6LN5Mc9abtVm4=";
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
