{
  lib,
  clangStdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  ctre,
  libllvm,
  libxml2,
  vapoursynth,
  darwinMinVersionHook,
}:
clangStdenv.mkDerivation rec {
  pname = "llvmexpr";
  # renovate: datasource=github-releases depName=Sunflower-Dolls/Vapoursynth-llvmexpr extractVersion=^R(?<version>.+)$
  version = "3.3";

  src = fetchFromGitHub {
    owner = "Sunflower-Dolls";
    repo = "Vapoursynth-llvmexpr";
    rev = "refs/tags/R${version}";
    hash = "sha256-zf4j9t9g0K5SiAMcNJsjOq7ohvi12kh070fzx4rEslM=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs =
    [
      ctre
      libllvm
      vapoursynth
    ]
    ++ lib.optionals clangStdenv.hostPlatform.isDarwin [
      (darwinMinVersionHook "13.3")
    ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
  '';

  mesonBuildType = "release";

  meta = with lib; {
    description = " Fast, enhanced and Turing complete Vapoursynth Expr base on LLVM JIT";
    homepage = "https://github.com/Sunflower-Dolls/Vapoursynth-llvmexpr";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
