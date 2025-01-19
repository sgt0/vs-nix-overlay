{
  lib,
  stdenv,
  fetchFromGitLab,
  vapoursynth,
  autoreconfHook,
}:
stdenv.mkDerivation {
  pname = "fmtc";
  version = "30-unstable-2025-01-19";

  src = fetchFromGitLab {
    owner = "EleonoreMizo";
    repo = "fmtconv";
    rev = "18a9cecba72287e3a2895ccc537aa1658059b4d0";
    hash = "sha256-fpsLGBTLGclGut0xHogpxlThKKvsz9g6f95xJf7Bk5o=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    vapoursynth
  ];

  preAutoreconf = "cd build/unix";
  configureFlags = ["--libdir=$(out)/lib/vapoursynth"];

  meta = with lib; {
    description = "Format conversion tools for Vapoursynth and Avisynth+";
    homepage = "https://gitlab.com/EleonoreMizo/fmtconv";
    license = licenses.wtfpl;
    platforms = platforms.all;
  };
}
