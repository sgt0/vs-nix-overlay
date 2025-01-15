{
  description = "vs-nix-overlay";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    packages = forAllSystems (system:
      import ./default.nix {
        pkgs = import nixpkgs {inherit system;};
      });

    devShells = forAllSystems (pkgs: {default = import ./shell.nix {inherit pkgs;};});

    formatter = forAllSystems (pkgs: pkgs.alejandra);
  };
}
