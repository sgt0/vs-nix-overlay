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
  darwinMinVersionHook,
}:
stdenv.mkDerivation rec {
  pname = "akarin_jet";
  # renovate: datasource=github-releases depName=Jaded-Encoding-Thaumaturgy/akarin-vapoursynth-plugin
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "akarin-vapoursynth-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-xXJ70I+gVNzijVJjly4n7/LXrS78ICttWm2Q4Q8JZiI=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs =
    [
      libllvm
      libxml2
      vapoursynth
    ]
    # `std::to_chars()` support.
    ++ lib.optional stdenv.hostPlatform.isDarwin (darwinMinVersionHook "26.0");

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
