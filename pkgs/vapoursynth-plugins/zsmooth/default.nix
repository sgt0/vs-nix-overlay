{
  lib,
  stdenv,
  fetchurl,
  unzip,
}: let
  assets = {
    x86_64-linux = {
      suffix = "x86_64-linux-gnu";
      hash = "sha256-yVWTZ/S9r4zDQIzIJx5DjFFhlrXt6kMFpp3tPi10ja4=";
    };
    aarch64-linux = {
      suffix = "aarch64-linux-gnu";
      hash = "sha256-0smEUflpCWWJxyfQbo8qd5y8izDA81ZBmhXa1AMmLKs=";
    };
    x86_64-darwin = {
      suffix = "x86_64-macos";
      hash = "sha256-jiTW2lsqbIKP3G8YthqW+zD/AkqDWmHYxZ8VAzdAHT0=";
    };
    aarch64-darwin = {
      suffix = "aarch64-macos";
      hash = "sha256-vkC893d6LZKdSA3/GuVUAqP3t5NWChpmoSzhen0yHEs=";
    };
  };
  asset =
    assets.${stdenv.hostPlatform.system}
    or (throw "zsmooth: unsupported system ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation rec {
    pname = "zsmooth";
    # renovate: datasource=github-releases depName=adworacz/zsmooth
    version = "0.19.0";

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
