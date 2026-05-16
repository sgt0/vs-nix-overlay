# Copyright (c) 2003-2025 Eelco Dolstra and the Nixpkgs/NixOS contributors
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
{
  lib,
  python3,
  buildEnv,
  runCommandCC,
  stdenv,
  runCommand,
  vapoursynth,
  makeWrapper,
  withPlugins,
}: plugins: let
  pythonEnvironment = python3.buildEnv.override {extraLibs = plugins;};

  getRecursivePropagatedBuildInputs = pkgs:
    lib.flatten (
      map (
        pkg: let
          cleanPropagatedBuildInputs = lib.filter lib.isDerivation pkg.propagatedBuildInputs;
        in
          cleanPropagatedBuildInputs ++ (getRecursivePropagatedBuildInputs cleanPropagatedBuildInputs)
      )
      pkgs
    );

  deepPlugins = lib.unique (plugins ++ (getRecursivePropagatedBuildInputs plugins));

  pluginsEnv = buildEnv {
    name = "vapoursynth-plugins-env";
    pathsToLink = ["/lib/vapoursynth"];
    paths = deepPlugins;
  };

  # Override default plugin path through nixPluginDir symbol
  nixPlugins =
    runCommandCC "libvapoursynth-nix-plugins${ext}"
    {
      executable = true;
      preferLocalBuild = true;
      allowSubstitutes = false;
      src = ''
        char const nixPluginDir[] = "${pluginsEnv}/lib/vapoursynth";
      '';
    }
    ''
      $CC -x c -shared -fPIC - -o "$out" <<<"$src"
    '';

  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
  if stdenv.hostPlatform.isDarwin
  then
    vapoursynth.overrideAttrs (previousAttrs: {
      pname = "vapoursynth-with-plugins";
      configureFlags =
        (previousAttrs.configureFlags or [])
        ++ [
          "--with-plugindir=${pluginsEnv}/lib/vapoursynth"
        ];
      postInstall = vapoursynth.postInstall + ''
        for pythonPlugin in ${pythonEnvironment}/${python3.sitePackages}/*; do
            ln -s $pythonPlugin $out/''${pythonPlugin#"${pythonEnvironment}/"}
        done
      '';
    })
  else
    runCommand "${vapoursynth.name}-with-plugins"
    {
      nativeBuildInputs = [makeWrapper];
      passthru = {
        inherit python3;
        inherit (vapoursynth) src version;
        withPlugins = plugins': withPlugins (plugins ++ plugins');
      };
    }
    ''
      mkdir -p \
        $out/bin \
        $out/lib/pkgconfig \
        $out/lib/vapoursynth \
        $out/${python3.sitePackages}

      for textFile in \
          lib/pkgconfig/vapoursynth{,-script}.pc \
          lib/libvapoursynth.la \
          lib/libvapoursynth-script.la \
          ${python3.sitePackages}/vapoursynth.la
      do
          substitute ${vapoursynth}/$textFile $out/$textFile \
              --replace-fail "${vapoursynth}" "$out"
      done

      for binaryPlugin in ${pluginsEnv}/lib/vapoursynth/*; do
          ln -s $binaryPlugin $out/''${binaryPlugin#"${pluginsEnv}/"}
      done

      for pythonPlugin in ${pythonEnvironment}/${python3.sitePackages}/*; do
          ln -s $pythonPlugin $out/''${pythonPlugin#"${pythonEnvironment}/"}
      done

      for binaryFile in \
          lib/libvapoursynth${ext} \
          lib/libvapoursynth-script${ext}.0.0.0
      do
        old_rpath=$(patchelf --print-rpath ${vapoursynth}/$binaryFile)
        new_rpath="$old_rpath:$out/lib"
        patchelf \
            --set-rpath "$new_rpath" \
            --output $out/$binaryFile \
            ${vapoursynth}/$binaryFile
        patchelf \
            --add-needed libvapoursynth-nix-plugins${ext} \
            $out/$binaryFile
      done

      for binaryFile in \
          ${python3.sitePackages}/vapoursynth${ext} \
          bin/.vspipe-wrapped
      do
          old_rpath=$(patchelf --print-rpath ${vapoursynth}/$binaryFile)
          new_rpath="''${old_rpath//"${vapoursynth}"/"$out"}"
          patchelf \
              --set-rpath "$new_rpath" \
              --output $out/$binaryFile \
              ${vapoursynth}/$binaryFile
      done

      ln -s ${nixPlugins} $out/lib/libvapoursynth-nix-plugins${ext}
      ln -s ${vapoursynth}/include $out/include
      ln -s ${vapoursynth}/lib/vapoursynth/* $out/lib/vapoursynth
      ln -s \
          libvapoursynth-script${ext}.0.0.0 \
          $out/lib/libvapoursynth-script${ext}
      ln -s \
          libvapoursynth-script${ext}.0.0.0 \
          $out/lib/libvapoursynth-script${ext}.0

      makeWrapper $out/bin/.vspipe-wrapped $out/bin/vspipe \
          --prefix PYTHONPATH : $out/${python3.sitePackages}
    ''
