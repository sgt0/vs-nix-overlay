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
  # renovate: datasource=github-releases depName=yuygfgg/Vapoursynth-llvmexpr extractVersion=^R(?<version>.+)$
  version = "3.2";

  src = fetchFromGitHub {
    owner = "yuygfgg";
    repo = "Vapoursynth-llvmexpr";
    rev = "refs/tags/R${version}";
    hash = "sha256-2Jr/jk1rZyse7IFQ0BSviEFziTV3bpT7pH1m3H5P+FQ=";
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
    homepage = "https://github.com/yuygfgg/Vapoursynth-llvmexpr";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
