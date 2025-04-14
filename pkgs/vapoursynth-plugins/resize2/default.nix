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
  version = "0.3.1-unstable-2025-03-14";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-resize2";
    rev = "7e600b5dddcbcd8d704e0135e1cc7a955d44b421";
    hash = "sha256-7oSjiN8DbfwhOsNe2wg3i6JkZ91vpBzZlHKOy5U8IjE=";
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
  };
}
