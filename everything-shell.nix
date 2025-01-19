# A Nix shell with VapourSynth and all plugins (from this overlay).
{
  pkgs ?
    import <nixpkgs> {
      overlays = [
        (import ./overlay.nix)
      ];
    },
}:
with pkgs; let
  vapoursynth = pkgs.vapoursynth.withPlugins [
    vapoursynthPlugins.bilateral
    vapoursynthPlugins.bs
    vapoursynthPlugins.colorbars
    vapoursynthPlugins.descale
    vapoursynthPlugins.ffms2
    vapoursynthPlugins.fftspectrum
    vapoursynthPlugins.miscfilters
    vapoursynthPlugins.placebo
    vapoursynthPlugins.removedirt
    vapoursynthPlugins.resize2
    vapoursynthPlugins.webp
  ];
in
  pkgs.mkShell {
    packages = [
      python3
      vapoursynth
    ];
  }
