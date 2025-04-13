{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  vapoursynth,
}:
rustPlatform.buildRustPackage rec {
  pname = "vsnlq";
  version = "1.1.1-unstable-2025-04-13";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "vs-nlq";
    rev = "7ca2893d6143bf7bcc829f6f40290e3fdb3f5da0";
    hash = "sha256-A5ASRcbd6Jw0cPTG4blzhetzyf+1xeqaSQab1Os06tY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  buildInputs = [
    vapoursynth
  ];

  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libvs_nlq${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libvs_nlq${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "";
    homepage = "https://github.com/quietvoid/vs-nlq";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
