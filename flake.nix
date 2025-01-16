{
  description = "vs-nix-overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }: let
    systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) (import ./default.nix {inherit pkgs;});

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          alejandra
          nil
          nixd
        ];
      };

      formatter = pkgs.alejandra;
    });
  in
    outputs
    // {
      overlays.default = final: prev: {
        vs-nix-overlay = outputs.packages.${prev.system};
      };
    };
}
