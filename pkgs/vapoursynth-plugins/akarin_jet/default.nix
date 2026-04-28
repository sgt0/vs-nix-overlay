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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "akarin-vapoursynth-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-g4KgEYS7s7IeJkx1ww1+2XxgkOW2uHmE6sIyDyVF6yE=";
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
    sed -i "/^py = /,/^incdir += inc_vs$/c\incdir += include_directories('${vapoursynth}/include/vapoursynth')" meson.build
    substituteInPlace meson.build \
      --replace-fail "install: false" "install: true, install_dir: get_option('libdir') / 'vapoursynth'"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = "Akarin's experimental VapourSynth plugin that provides an LLVM-based enhanced Expr (aka lexpr), and NVidia Deep Learning based super-resolution (DLISR) and video effect (DLVFX) filters";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/akarin-vapoursynth-plugin";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
