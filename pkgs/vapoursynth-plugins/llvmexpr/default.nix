{
  lib,
  clangStdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libllvm,
  libxml2,
  vapoursynth,
  darwinMinVersionHook,
}:
clangStdenv.mkDerivation rec {
  pname = "llvmexpr";
  # renovate: datasource=github-releases depName=yuygfgg/Vapoursynth-llvmexpr extractVersion=^R(?<version>.+)$
  version = "3.1";

  src = fetchFromGitHub {
    owner = "yuygfgg";
    repo = "Vapoursynth-llvmexpr";
    rev = "refs/tags/R${version}";
    hash = "sha256-Eq9VYDrMtmFAiYDyAsestVmpRNLGEjT5HzLB/31J56s=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs =
    [
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
    homepage = "https://github.com/yuygfgg/Vapoursynth-llvmexpr";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
