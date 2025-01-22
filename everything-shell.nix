# A Nix shell with VapourSynth and all plugins (from this overlay).
{
  pkgs ?
    import <nixpkgs> {
      config.allowUnfree = true;
      overlays = [
        (import ./overlay.nix)
      ];
    },
}:
with pkgs; let
  vapoursynth = pkgs.vapoursynth.withPlugins [
    vapoursynthPlugins.akarin
    vapoursynthPlugins.bilateral
    vapoursynthPlugins.bs
    vapoursynthPlugins.colorbars
    vapoursynthPlugins.descale
    vapoursynthPlugins.ffms2
    vapoursynthPlugins.fftspectrum
    vapoursynthPlugins.median
    vapoursynthPlugins.miscfilters
    vapoursynthPlugins.placebo
    vapoursynthPlugins.removedirt
    vapoursynthPlugins.resize2
    vapoursynthPlugins.tivtc
    vapoursynthPlugins.vivtc
    vapoursynthPlugins.webp
  ];
in
  pkgs.mkShell {
    packages = [
      python3
      vapoursynth
    ];
  }
