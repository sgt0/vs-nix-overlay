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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-resize2";
    rev = "refs/tags/${version}";
    hash = "sha256-BX8qFrZcGBP6aYgbfljqEGOUZrfMwmfopoN6NJebrsA=";
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
          --replace-fail "py = import('python').find_installation()
    vapoursynth_include_command = run_command(
        py,
        '-c',
        'import vapoursynth as vs; print(vs.get_include())',
        check: true,
    )
    vapoursynth_include = include_directories(vapoursynth_include_command.stdout().strip())" \
          "vapoursynth_dep = dependency('vapoursynth')
    vapoursynth_include = include_directories(vapoursynth_dep.get_variable(pkgconfig: 'includedir'))" \
          --replace-fail "py.get_install_dir(pure: false) / 'vapoursynth' / 'plugins'" "get_option('libdir') / 'vapoursynth'"

        substituteInPlace subprojects/zimg/meson.build \
          --replace-fail "py = import('python').find_installation()
    vapoursynth_include_command = run_command(
        py,
        '-c',
        'import vapoursynth as vs; print(vs.get_include())',
        check: true,
    )
    vapoursynth_include = include_directories(vapoursynth_include_command.stdout().strip())" \
          "vapoursynth_dep = dependency('vapoursynth')
    vapoursynth_include = include_directories(vapoursynth_dep.get_variable(pkgconfig: 'includedir'))"
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
