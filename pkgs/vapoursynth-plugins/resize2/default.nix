{
  lib,
  stdenv,
  fetchFromGitHub,
  cacert,
  git,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation {
  pname = "resize2";
  version = "0.3.1-unstable-2025-01-19";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-resize2";
    rev = "f2c97f8cff2e2adf56c1e8756cc8b81104ac9685";
    hash = "sha256-CMTeaYtTlquqAEZ4zCzMF3S0doBdKK3fwFgLpDFN1PE=";
    nativeBuildInputs = [
      cacert
      git
      meson
    ];
    postFetch = ''
      (
        cd "$out"
        for prj in subprojects/*.wrap; do
          meson subprojects download "$(basename "$prj" .wrap)"
          rm -rf subprojects/$(basename "$prj" .wrap)/.git
        done
      )
    '';
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=format-security -march=x86-64-v4";

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
      --replace-fail "link_args: ['-static']," "# link_args: ['-static']," \
      --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";
  mesonWrapMode = "default";

  meta = with lib; {
    description = "resize2";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-resize2";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
