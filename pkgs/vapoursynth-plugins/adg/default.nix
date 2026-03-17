{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "adg";
  # renovate: datasource=github-releases depName=kageru/adaptivegrain
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "kageru";
    repo = "adaptivegrain";
    rev = "refs/tags/${version}";
    hash = "sha256-MCc/l86kAARj9KYQfyHDOYyxmrN+YRVJbu24IELp52s=";
  };

  cargoHash = "sha256-RlbSxS3uqrlihPIZZrbUYeAAEY6huMo9pdmLgEoieOg=";

  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libadaptivegrain_rs${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libadaptivegrain_rs${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  meta = with lib; {
    description = "Reimplementation of the adaptive_grain mask as a Vapoursynth plugin.";
    homepage = "https://github.com/kageru/adaptivegrain";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
