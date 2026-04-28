{
  description = "vs-nix-overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

    isBuildable = pkgs: p: let
      licenseFromMeta = p.meta.license or [];
      licenseList =
        if builtins.isList licenseFromMeta
        then licenseFromMeta
        else [licenseFromMeta];
    in
      pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform p
      && !(p.meta.broken or false)
      && builtins.all (license: license.free or true) licenseList;

    isCacheable = p: !(p.preferLocalBuild or false);

    systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      defaultPkgs = import ./default.nix {inherit pkgs;};
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
        defaultPkgs;

      ciPackages = let
        flatPlugins =
          nixpkgs.lib.concatMapAttrs
          (k: v:
            if nixpkgs.lib.isDerivation v
            then {"vapoursynthPlugins-${k}" = v;}
            else {})
          (defaultPkgs.vapoursynthPlugins or {});

        flatVapoursynth =
          nixpkgs.lib.filterAttrs
          (k: v:
            nixpkgs.lib.isDerivation v
            && nixpkgs.lib.hasPrefix "vapoursynth_" k)
          defaultPkgs;

        allPkgs = flatVapoursynth // flatPlugins;
      in
        nixpkgs.lib.filterAttrs
        (_: v: isBuildable pkgs v && isCacheable v)
        allPkgs;

      mkPluginCheck = {
        pluginName,
        vsVersion,
        pythonAttr ? pluginName,
      }: let
        vsAttr = "vapoursynth_${vsVersion}";
        pluginAttr = pluginName;
        checkName = "vs${vsVersion}-${pluginName}-check";
      in
        pkgs.runCommandLocal checkName
        {
          nativeBuildInputs = with pkgs; [
            python3
            (packages.${vsAttr}.withPlugins [
              packages.vapoursynthPlugins.${pluginAttr}
            ])
          ];
        }
        ''
          python -c "import vapoursynth; print(vapoursynth.core); print(vapoursynth.core.${pythonAttr})"
          touch $out
        '';
    in {
      inherit packages ciPackages;

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          alejandra
          nil
          nixd
        ];
      };

      formatter = pkgs.alejandra;

      checks = let
        vsVersions = ["67" "68" "69" "70" "71" "72" "73"];
        plugins = ["bs" "cambi" "descale" "eedi3m" "ffms2" "resize2" "vszip" "zscene"];
        combinations = nixpkgs.lib.cartesianProduct {
          vsVersion = vsVersions;
          pluginName = plugins;
        };
      in
        nixpkgs.lib.listToAttrs
        (map
          ({
            vsVersion,
            pluginName,
          }:
            nixpkgs.lib.nameValuePair
            "vs${vsVersion}-${pluginName}"
            (mkPluginCheck {
              inherit pluginName vsVersion;
            }))
          combinations);
    });
  in
    outputs
    // {
      overlays.default = final: prev: {
        vspkgs = outputs.packages.${prev.system};
      };

      templates = {
        simple-flake = {
          path = ./examples/simple-flake;
          description = "A flake using flake-utils.lib.simpleFlake and vs-nix-overlay";
        };
      };
    };
}
