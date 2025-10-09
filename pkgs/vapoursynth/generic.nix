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
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  makeWrapper,
  runCommandCC,
  runCommand,
  buildEnv,
  zimg,
  libass,
  python3,
  testers,
  version,
  hash,
  darwinMinVersionHook,
} @ args:
stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth";
  inherit version;

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vapoursynth";
    rev = "R${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    makeWrapper
  ];
  buildInputs =
    [
      zimg
      libass
      (python3.withPackages (
        ps:
          with ps; [
            sphinx
            cython
          ]
      ))
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (darwinMinVersionHook "13.3")
    ];

  enableParallelBuilding = true;
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  passthru = rec {
    # If vapoursynth is added to the build inputs of mpv and then
    # used in the wrapping of it, we want to know once inside the
    # wrapper, what python3 version was used to build vapoursynth so
    # the right python3.sitePackages will be used there.
    inherit python3;

    withPlugins = import ./plugin-interface.nix {
      vapoursynth = finalAttrs.finalPackage;
      inherit
        lib
        python3
        buildEnv
        runCommandCC
        stdenv
        runCommand
        makeWrapper
        withPlugins
        ;
    };

    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      # Check Core version to prevent false positive with API version
      version = "Core R${finalAttrs.version}";
    };
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # Export weak symbol nixPluginDir to permit override of default plugin path
    sed -E -i \
      -e 's/(VS_PATH_PLUGINDIR)/(nixPluginDir ? nixPluginDir : \1)/g' \
      -e '1i\extern char const __attribute__((weak)) nixPluginDir[];' \
      src/core/vscore.cpp
  '';

  postInstall = ''
    wrapProgram $out/bin/vspipe \
        --prefix PYTHONPATH : $out/${python3.sitePackages}

    # VapourSynth does not include any plugins by default
    # and emits a warning when the system plugin directory does not exist.
    mkdir $out/lib/vapoursynth
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    libv="$out/lib/libvapoursynth${stdenv.hostPlatform.extensions.sharedLibrary}"
    if ! $NM -g -P "$libv" | grep -q '^nixPluginDir w'; then
      echo "Weak symbol nixPluginDir is missing from $libv." >&2
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Video processing framework with the future in mind";
    homepage = "http://www.vapoursynth.com/";
    license = licenses.lgpl21;
    platforms = platforms.all;
    mainProgram = "vspipe";
  };
})
