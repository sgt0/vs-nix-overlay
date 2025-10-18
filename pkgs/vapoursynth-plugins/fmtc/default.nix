{
  lib,
  stdenv,
  fetchFromGitLab,
  vapoursynth,
  autoreconfHook,
}:
stdenv.mkDerivation {
  pname = "fmtc";
  version = "30-unstable-2025-10-18";

  src = fetchFromGitLab {
    owner = "EleonoreMizo";
    repo = "fmtconv";
    rev = "259b702e4e3c1e2fc6d7b2c8e83d95b612519e89";
    hash = "sha256-u/j7Z+BHRxqcAw1GfI3XJixz2m/NnM8ROKRNE0lZxnc=";
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
