{
  lib,
  newScope,
  config,
}:
lib.makeScope newScope (self:
    with self;
      {
        bilateral = callPackage ./bilateral {};
        bs = callPackage ./bs {};
        colorbars = callPackage ./colorbars {};
        descale = callPackage ./descale {};
        ffms2 = callPackage ./ffms2 {};
        fftspectrum = callPackage ./fftspectrum {};
        fh = callPackage ./fh {};
        fmtc = callPackage ./fmtc {};
        fpng = callPackage ./fpng {};
        median = callPackage ./median {};
        miscfilters = callPackage ./miscfilters {};
        placebo = callPackage ./placebo {};
        placebo_sgt0 = callPackage ./placebo_sgt0 {};
        removedirt = callPackage ./removedirt {};
        resize2 = callPackage ./resize2 {};
        tivtc = callPackage ./tivtc {};
        webp = callPackage ./webp {};
        zsmooth = callPackage ./zsmooth {};

        # Requires Zig nightly.
        # manipmv = callPackage ./manipmv {};
        # vszip = callPackage ./vszip {};
      }
      // lib.optionalAttrs config.allowAliases {
        # Aliases.
        bestsource = bs;
      })
