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
    attrDerivations = set: path: (nixpkgs.lib.concatMapAttrs
      (k: v:
        if nixpkgs.lib.isDerivation v
        then {${builtins.concatStringsSep "." (path ++ [k])} = v;}
        else if builtins.isAttrs v
        then attrDerivations v (path ++ [k])
        else {})
      set);

    systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages =
        nixpkgs.lib.concatMapAttrs
        (k: v:
          if nixpkgs.lib.isDerivation v
          then {${k} = v;}
          else if nixpkgs.lib.isFunction v
          then {
            ${k} = {
              type = "derivation";
              name = "dummy-function";
              __functor = _: v;
            };
          }
          else if builtins.isAttrs v
          then
            attrDerivations v [k]
            // {
              ${k} =
                {
                  type = "derivation";
                  name = "dummy-attrset";
                }
                // v;
            }
          else v)
        (import ./default.nix {inherit pkgs;});

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
        vspkgs = outputs.packages.${prev.system};
      };
    };
}
