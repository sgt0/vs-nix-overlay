{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
  pkg-config,
  ctre,
  libllvm,
  libxml2,
  shaderc,
  vapoursynth,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  vulkan-volk,
  darwinMinVersionHook,
}:
clangStdenv.mkDerivation rec {
  pname = "llvmexpr";
  # renovate: datasource=github-releases depName=Sunflower-Dolls/Vapoursynth-llvmexpr extractVersion=^R(?<version>.+)$
  version = "4.4";

  src = fetchFromGitHub {
    owner = "Sunflower-Dolls";
    repo = "Vapoursynth-llvmexpr";
    rev = "refs/tags/R${version}";
    hash = "sha256-wCWSLPEYB7ctz1t7cCQMVzHIFV6yVD+a0JprFvWEYtU=";
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    [
      ctre
      libllvm
      shaderc
      vapoursynth
      vulkan-headers
      vulkan-loader
      vulkan-memory-allocator
      vulkan-volk
    ]
    ++ lib.optionals clangStdenv.hostPlatform.isDarwin [
      (darwinMinVersionHook "13.3")
    ];

  dontUseCmakeConfigure = true;

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
