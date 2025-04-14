{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "removedirt";
  # renovate: datasource=github-tags depName=pinterf/RemoveDirt
  version = "1.1";

  src = fetchFromGitHub {
    owner = "pinterf";
    repo = "RemoveDirt";
    rev = "refs/tags/v${version}";
    hash = "sha256-564o1iB9MVoTGByakj1UEKaEEfGKKI6yXEgiLaDNdv4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vapoursynth
  ];

  postPatch = ''
    substituteInPlace RemoveDirt/CMakeLists.txt \
      --replace-fail "/avisynth" "/vapoursynth"
  '';

  meta = with lib; {
    description = "Removes Dirt";
    homepage = "https://github.com/pinterf/RemoveDirt";
    license = licenses.gpl2;
    platforms = platforms.all;
    broken = stdenv.cc.isClang; # common.cpp:26:19: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
  };
}
