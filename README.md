# vs-nix-overlay

## Usage

```nix
# flake.nix
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
