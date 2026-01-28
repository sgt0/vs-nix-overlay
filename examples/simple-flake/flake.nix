{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    vs-nix-overlay = {
      url = "github:sgt0/vs-nix-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    vs-nix-overlay,
  }:
    flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "simple-flake";
      preOverlays = [vs-nix-overlay.overlays.default];
      shell = {pkgs ? import <nixpkgs>}:
        pkgs.mkShell {
          packages = with pkgs; [
            python312
            uv

            (vspkgs.vapoursynth_73.withPlugins [
              vspkgs.vapoursynthPlugins.akarin_jet
              vspkgs.vapoursynthPlugins.resize2
              vspkgs.vapoursynthPlugins.vszip
            ])
          ];

          env =
            {
              UV_PYTHON_DOWNLOADS = "never";
              UV_PYTHON_PREFERENCE = "only-system";
            }
            // (pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
              LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
            });

          shellHook = ''
            uv sync
            . .venv/bin/activate
          '';
        };
    };
}
