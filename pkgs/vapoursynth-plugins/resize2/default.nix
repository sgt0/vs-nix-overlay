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
stdenv.mkDerivation rec {
  pname = "resize2";
  # renovate: datasource=github-releases depName=Jaded-Encoding-Thaumaturgy/vapoursynth-resize2
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-resize2";
    rev = "refs/tags/${version}";
    hash = "sha256-mmFr65dpR7W7g3rBP6UikSSYpS+NIhwYrBj31xP01HI=";
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

  env = {
    NIX_CFLAGS_COMPILE = toString (
      []
      ++ lib.optionals stdenv.cc.isGNU ["-Wno-error=format-security"]
    );
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
    broken = stdenv.cc.isClang; # clang++: error: unsupported argument 'armv7-a' to option '-march='
  };
}
