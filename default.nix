{pkgs ? import <nixpkgs> {}}: {
  vapoursynthPlugins = pkgs.recurseIntoAttrs (pkgs.callPackage ./pkgs/vapoursynth-plugins {});
}
