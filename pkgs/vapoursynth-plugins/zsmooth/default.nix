{
  lib,
  stdenv,
  fetchurl,
  unzip,
}: let
  assets = {
    x86_64-linux = {
      suffix = "x86_64-linux-gnu";
      hash = "sha256-O0iV+bexNfxBiA0SAQp+iimGV3IsqDKC2ny7nbZjvDA=";
    };
    aarch64-linux = {
      suffix = "aarch64-linux-gnu";
      hash = "sha256-zEx6X11zsfNMQqDp5CHI8S34t9QWIRqLGf3heKcucQM=";
    };
    x86_64-darwin = {
      suffix = "x86_64-macos";
      hash = "sha256-BO+nLwD85AcJBppz96dg7eZ+Oq9xTc5Ux17t8Ie+3qU=";
    };
    aarch64-darwin = {
      suffix = "aarch64-macos";
      hash = "sha256-O2gv2T6tmwvS2PJwn7CvMLlFQfhEghOy8TKTnSt/P1Q=";
    };
  };
  asset =
    assets.${stdenv.hostPlatform.system}
    or (throw "zsmooth: unsupported system ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation rec {
    pname = "zsmooth";
    # renovate: datasource=github-releases depName=adworacz/zsmooth
    version = "0.20.0";

    src = fetchurl {
      url = "https://github.com/adworacz/zsmooth/releases/download/${version}/zsmooth-${asset.suffix}.zip";
      inherit (asset) hash;
    };

    nativeBuildInputs = [
      unzip
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      install -Dm644 libzsmooth${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libzsmooth${stdenv.hostPlatform.extensions.sharedLibrary}
      mkdir -p $out/lib/vapoursynth
      ln -s $out/lib/libzsmooth${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/vapoursynth/libzsmooth${stdenv.hostPlatform.extensions.sharedLibrary}

      runHook postInstall
    '';

    meta = with lib; {
      description = "Cross-platform smoothing functions written in Zig";
      homepage = "https://github.com/adworacz/zsmooth";
      license = licenses.mit;
      sourceProvenance = [sourceTypes.binaryNativeCode];
      platforms = attrNames assets;
    };
  }
