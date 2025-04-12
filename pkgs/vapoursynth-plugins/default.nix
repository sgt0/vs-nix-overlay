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
        eedi3m = callPackage ./eedi3m {};
        ffms2 = callPackage ./ffms2 {};
        fftspectrum = callPackage ./fftspectrum {};
        fh = callPackage ./fh {};
        fmtc = callPackage ./fmtc {};
        fpng = callPackage ./fpng {};
        median = callPackage ./median {};
        miscfilters = callPackage ./miscfilters {};
        neo_tmedian = callPackage ./neo_tmedian {};
        nlm_cuda = callPackage ./nlm_cuda {};
        placebo = callPackage ./placebo {};
        placebo_sgt0 = callPackage ./placebo_sgt0 {};
        removedirt = callPackage ./removedirt {};
        resize2 = callPackage ./resize2 {};
        retinex = callPackage ./retinex {};
        rgvs = callPackage ./rgvs {};
        tivtc = callPackage ./tivtc {};
        tmedian = callPackage ./tmedian {};
        vivtc = callPackage ./vivtc {};
        vszip = callPackage ./vszip {};
        webp = callPackage ./webp {};
        zsmooth = callPackage ./zsmooth {};

        # Requires Zig nightly.
        # manipmv = callPackage ./manipmv {};
      }
      // lib.optionalAttrs config.allowAliases {
        # Aliases.
        bestsource = bs;
      })
