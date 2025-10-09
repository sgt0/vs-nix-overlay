{pkgs ? import <nixpkgs> {}}: {
  inherit
    (rec {
      vapoursynthPackages = pkgs.recurseIntoAttrs (pkgs.callPackage ./pkgs/vapoursynth {});

      vapoursynth_67 = vapoursynthPackages."67";
      vapoursynth_68 = vapoursynthPackages."68";
      vapoursynth_69 = vapoursynthPackages."69";
      vapoursynth_70 = vapoursynthPackages."70";
      vapoursynth_71 = vapoursynthPackages."71";
      vapoursynth_72 = vapoursynthPackages."72";
    })
    vapoursynthPackages
    vapoursynth_67
    vapoursynth_68
    vapoursynth_69
    vapoursynth_70
    vapoursynth_71
    vapoursynth_72
    ;

  vapoursynthPlugins = pkgs.recurseIntoAttrs (pkgs.callPackage ./pkgs/vapoursynth-plugins {});
}
