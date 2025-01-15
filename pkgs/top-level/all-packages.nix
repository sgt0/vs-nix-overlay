{
  lib,
  noSysDirs,
  config,
  overlays,
}: res: pkgs: super:
with pkgs; {
  vapoursynthPlugins = recurseIntoAttrs (callPackage ../vapoursynth-plugins {});
}
