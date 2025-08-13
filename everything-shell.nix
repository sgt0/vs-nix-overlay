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
    vapoursynthPlugins.depan
    vapoursynthPlugins.descale
    vapoursynthPlugins.dfttest
    vapoursynthPlugins.ffms2
    vapoursynthPlugins.fftspectrum
    vapoursynthPlugins.fftspectrum_rs
    vapoursynthPlugins.median
    vapoursynthPlugins.miscfilters
    vapoursynthPlugins.mv
    vapoursynthPlugins.neo_tmedian
    vapoursynthPlugins.nlm_cuda
    vapoursynthPlugins.placebo
    vapoursynthPlugins.raws
    vapoursynthPlugins.removedirt
    vapoursynthPlugins.resize2
    vapoursynthPlugins.retinex
    vapoursynthPlugins.rgvs
    vapoursynthPlugins.sneedif
    vapoursynthPlugins.tivtc
    vapoursynthPlugins.tmedian
    vapoursynthPlugins.vivtc
    vapoursynthPlugins.vszip
    vapoursynthPlugins.webp
  ];
in
  pkgs.mkShell {
    packages = [
      python3
      vapoursynth
    ];
  }
