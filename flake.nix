{
  description = "vs-nix-overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
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

      checks = {
        vs67 =
          pkgs.runCommandLocal "vs67-check"
          {
            nativeBuildInputs = with pkgs; [
              python312
              (outputs.packages.${system}.vapoursynth_67.withPlugins [
                outputs.packages.${system}.vapoursynthPlugins.akarin_jet
              ])
            ];
          }
          ''
            python -c "import vapoursynth; print(vapoursynth.core); print(vapoursynth.core.akarin)"
            touch $out
          '';

        vs68 =
          pkgs.runCommandLocal "vs68-check"
          {
            nativeBuildInputs = with pkgs; [
              python312
              (outputs.packages.${system}.vapoursynth_68.withPlugins [
                outputs.packages.${system}.vapoursynthPlugins.bs
              ])
            ];
          }
          ''
            python -c "import vapoursynth; print(vapoursynth.core); print(vapoursynth.core.bs)"
            touch $out
          '';

        vs69 =
          pkgs.runCommandLocal "vs69-check"
          {
            nativeBuildInputs = with pkgs; [
              python312
              (outputs.packages.${system}.vapoursynth_69.withPlugins [
                outputs.packages.${system}.vapoursynthPlugins.cambi
              ])
            ];
          }
          ''
            python -c "import vapoursynth; print(vapoursynth.core); print(vapoursynth.core.cambi)"
            touch $out
          '';

        vs70 =
          pkgs.runCommandLocal "vs70-check"
          {
            nativeBuildInputs = with pkgs; [
              python312
              (outputs.packages.${system}.vapoursynth_70.withPlugins [
                outputs.packages.${system}.vapoursynthPlugins.descale
              ])
            ];
          }
          ''
            python -c "import vapoursynth; print(vapoursynth.core); print(vapoursynth.core.descale)"
            touch $out
          '';

        vs71 =
          pkgs.runCommandLocal "vs71-check"
          {
            nativeBuildInputs = with pkgs; [
              python312
              (outputs.packages.${system}.vapoursynth_71.withPlugins [
                outputs.packages.${system}.vapoursynthPlugins.ffms2
              ])
            ];
          }
          ''
            python -c "import vapoursynth; print(vapoursynth.core); print(vapoursynth.core.ffms2)"
            touch $out
          '';
      };
    });
  in
    outputs
    // {
      overlays.default = final: prev: {
        vspkgs = outputs.packages.${prev.system};
      };
    };
}
