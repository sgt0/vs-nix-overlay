{
  lib,
  newScope,
  config,
}:
lib.makeScope newScope (self:
    with self;
      {
        bestsource = callPackage ./bestsource {};
        bilateral = callPackage ./bilateral {};
        ffms2 = callPackage ./ffms2 {};
        fftspectrum = callPackage ./fftspectrum {};
        fh = callPackage ./fh {};
        fmtc = callPackage ./fmtc {};
        fpng = callPackage ./fpng {};
        miscfilters = callPackage ./miscfilters {};
        placebo = callPackage ./placebo {};
        placebo_sgt0 = callPackage ./placebo_sgt0 {};
        removedirt = callPackage ./removedirt {};
        resize2 = callPackage ./resize2 {};
        webp = callPackage ./webp {};

        # Requires Zig nightly.
        # manipmv = callPackage ./manipmv {};
        # vszip = callPackage ./vszip {};
      }
      // lib.optionalAttrs config.allowAliases {
        # Aliases could go here.
      })
