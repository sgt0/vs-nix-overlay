{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "fh";
  # renovate: datasource=github-releases depName=dubhater/vapoursynth-fieldhint
  version = "5";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-fieldhint";
    rev = "refs/tags/v${version}";
    hash = "sha256-NnSPGh60VdhE7W8lJ35KQdQnSTl8XMlVZ5wtLTEqzTo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  postPatch = ''
        substituteInPlace meson.build \
          --replace-fail \
            "incdir = include_directories(
        run_command(
            find_program('python', 'python3'),
            '-c',
            'import vapoursynth as vs; print(vs.get_include())',
            check: true,
        ).stdout().strip(),
    )

    py = import('python').find_installation(pure: false)

    shared_module('fieldhint',
        files('src/fieldhint.c'),
        gnu_symbol_visibility: 'hidden',
        include_directories: incdir,
        install: true,
        install_dir: py.get_install_dir() / 'vapoursynth/plugins',
        name_prefix: ''',
    )" \
            "vapoursynth_dep = dependency('vapoursynth')

    shared_module('fieldhint',
        files('src/fieldhint.c'),
        dependencies: vapoursynth_dep,
        gnu_symbol_visibility: 'hidden',
        install: true,
        install_dir: get_option('libdir'),
        name_prefix: ''',
    )"
  '';

  mesonBuildType = "release";
  mesonFlags = ["--libdir=${placeholder "out"}/lib/vapoursynth"];

  meta = with lib; {
    description = "FieldHint Plugin";
    homepage = "https://github.com/dubhater/vapoursynth-fieldhint";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
