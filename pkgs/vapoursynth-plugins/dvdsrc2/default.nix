{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  a52dec,
  libmpeg2,
}:
rustPlatform.buildRustPackage rec {
  pname = "dvdsrc2";
  version = "0.0.0-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "jsaowji";
    repo = "dvdsrc2";
    rev = "905e86be29adaa8adbbbd7c3675a3cec4942e057";
    hash = "sha256-tDkBt3wIhe3ABIydm3dGP4TiBX2LvVOaS/q6L11RZU0=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Nzxk2M8sWh4UkreFaw9byk4ORSlu/9sPkfesK5kbJIs=";

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    a52dec
    libmpeg2
  ];

  # `libdvdread-sys/build.rs` shells out to meson.
  dontUseMesonConfigure = true;
  dontUseMesonInstall = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libdvdsrc2${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libdvdsrc2${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "DVD source plugin for VapourSynth";
    homepage = "https://github.com/jsaowji/dvdsrc2";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
