{
  lib,
  newScope,
  config,
}:
lib.makeScope newScope (self:
    with self;
      {
        akarin = callPackage ./akarin {};
        akarin_jet = callPackage ./akarin_jet {};
        ares = callPackage ./ares {};
        bilateral = callPackage ./bilateral {};
        bs = callPackage ./bs {};
        carefulsource = callPackage ./carefulsource {};
        colorbars = callPackage ./colorbars {};
        descale = callPackage ./descale {};
        eedi2 = callPackage ./eedi2 {};
        ffms2 = callPackage ./ffms2 {};
        fftspectrum = callPackage ./fftspectrum {};
        fh = callPackage ./fh {};
        fmtc = callPackage ./fmtc {};
        fpng = callPackage ./fpng {};
        median = callPackage ./median {};
        miscfilters = callPackage ./miscfilters {};
        nlm_cuda = callPackage ./nlm_cuda {};
        placebo = callPackage ./placebo {};
        placebo_sgt0 = callPackage ./placebo_sgt0 {};
        removedirt = callPackage ./removedirt {};
        resize2 = callPackage ./resize2 {};
        tivtc = callPackage ./tivtc {};
        vivtc = callPackage ./vivtc {};
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
