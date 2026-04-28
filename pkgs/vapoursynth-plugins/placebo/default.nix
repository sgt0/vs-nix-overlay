{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libplacebo,
  vapoursynth,
  vulkan-headers,
}: let
  libp2pRev = "f50288b0c8db2cb14bb98fc25a5f056609d03652";
  libp2p = fetchurl {
    url = "https://github.com/sekrit-twc/libp2p/archive/${libp2pRev}.tar.gz";
    hash = "sha256-N7FL5bEQgmjlWqT7r4OMKHAY7MW1jhXv3+BkkWr8ROk=";
  };
in
  stdenv.mkDerivation rec {
    pname = "placebo";
    # renovate: datasource=github-releases depName=Lypheo/vs-placebo
    version = "2.0.2";

    src = fetchFromGitHub {
      owner = "Lypheo";
      repo = "vs-placebo";
      rev = "refs/tags/${version}";
      hash = "sha256-08BGiEQ5mVQhyH/erFFLvEzqNSz0kHyhe/BLXspae1k=";
    };

    nativeBuildInputs = [
      pkg-config
      meson
      ninja
    ];

    buildInputs = [
      libplacebo
      vapoursynth
      vulkan-headers
    ];

    postPatch = ''
      mkdir -p subprojects/libp2p-${libp2pRev}
      tar -xzf ${libp2p} --strip-components=1 -C subprojects/libp2p-${libp2pRev}
      cp subprojects/packagefiles/libp2p-${libp2pRev}/* subprojects/libp2p-${libp2pRev}/

      substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
    '';

    mesonFlags = ["-Dr73-compat=true"];
    mesonBuildType = "release";

    meta = with lib; {
      description = "libplacebo-based debanding, scaling and color mapping plugin for VapourSynth";
      homepage = "https://github.com/Lypheo/vs-placebo";
      license = licenses.lgpl21;
      platforms = platforms.all;
    };
  }
