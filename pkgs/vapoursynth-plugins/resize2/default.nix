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
  version = "0.3.2-unstable-2025-05-29";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-resize2";
    rev = "f665219bd1be491eac04cef3f55c950712c05e1b";
    hash = "sha256-KcPmZmTtbzT//7XPFkhl/arQQy9NVFxvRZO1mbnuDJ8=";
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
