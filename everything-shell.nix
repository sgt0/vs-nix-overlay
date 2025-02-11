# A Nix shell with VapourSynth and all plugins (from this overlay).
{
  pkgs ?
    import <nixpkgs> {
      config.allowUnfree = true;
      config.cudaSupport = true;
      overlays = [
        (import ./overlay.nix)
      ];
    },
}:
with pkgs; let
  vapoursynth = pkgs.vapoursynth.withPlugins [
    vapoursynthPlugins.akarin
    vapoursynthPlugins.ares
    vapoursynthPlugins.bilateral
    vapoursynthPlugins.bs
    vapoursynthPlugins.colorbars
    vapoursynthPlugins.descale
    vapoursynthPlugins.ffms2
    vapoursynthPlugins.fftspectrum
    vapoursynthPlugins.median
    vapoursynthPlugins.miscfilters
    vapoursynthPlugins.nlm_cuda
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
