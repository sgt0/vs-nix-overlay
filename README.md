# vs-nix-overlay

An experiment in using [Nix](https://nixos.wiki/wiki/Nix_package_manager) as a
package manager for [VapourSynth](https://www.vapoursynth.com/) packages. This
project provides a [Nix overlay](https://nixos.wiki/wiki/Overlays) containing
many VapourSynth plugins.

While a package manager for VapourSynth already exists in
[vsrepo](https://github.com/vapoursynth/vsrepo), it generally does not include
macOS and Linux builds, even for plugins whose authors provide them. This has
led to Arch Linux being the [recommended](https://jaded-encoding-thaumaturgy.github.io/JET-guide/master/basics/installation/)
distribution for encoding with VapourSynth because its AUR covers more plugins
than what is offered on other distributions. A potential goal of this project is
to improve this situation by providing a distro-agnostic means of installing
VapourSynth plugins.

## Usage

In a `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # 1. Add input.
    vs-nix-overlay.url = "github:sgt0/vs-nix-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    vs-nix-overlay,
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;

        # 2. Add overlay.
        overlays = [
          vs-nix-overlay.overlays.default
        ];
      };
    in {
      devShells = {
        default =
          pkgs.mkShell
          {
            nativeBuildInputs = with pkgs; [
              # 3. Define a VapourSynth environment with plugins.
              python312
              (vapoursynth.withPlugins [
                vspkgs.vapoursynthPlugins.bilateral
                vspkgs.vapoursynthPlugins.resize2
                # etc.
              ])
            ];
          };
      };
    });
}
```

## Past VapourSynth versions

In addition to VapourSynth plugins, this overlay also provides packages for the
last few VapourSynth versions:

- `vspkgs.vapoursynth_67`
- `vspkgs.vapoursynth_68`
- `vspkgs.vapoursynth_69`
- `vspkgs.vapoursynth_70`

```nix
{
  # ...

  nativeBuildInputs = with pkgs; [
    # Define a VapourSynth R67 environment with plugins.
    python312
    (vspkgs.vapoursynth_67.withPlugins [
      vspkgs.vapoursynthPlugins.akarin
      vspkgs.vapoursynthPlugins.vszip
      # etc.
    ])
  ];

  #...
}
```

## Prior art

- [nix-community/vs-overlay](https://github.com/nix-community/vs-overlay)
- [sandydoo/vapoursynth-on-nix](https://github.com/sandydoo/vapoursynth-on-nix)
