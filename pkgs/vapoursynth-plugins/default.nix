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
        cambi = callPackage ./cambi {};
        carefulsource = callPackage ./carefulsource {};
        colorbars = callPackage ./colorbars {};
        depan = callPackage ./depan {};
        descale = callPackage ./descale {};
        dfttest = callPackage ./dfttest {};
        eedi2 = callPackage ./eedi2 {};
        eedi3m = callPackage ./eedi3m {};
        ffms2 = callPackage ./ffms2 {};
        fftspectrum = callPackage ./fftspectrum {};
        fftspectrum_rs = callPackage ./fftspectrum_rs {};
        fh = callPackage ./fh {};
        fmtc = callPackage ./fmtc {};
        fpng = callPackage ./fpng {};
        median = callPackage ./median {};
        miscfilters = callPackage ./miscfilters {};
        mv = callPackage ./mv {};
        neo_f3kdb = callPackage ./neo_f3kdb {};
        neo_tmedian = callPackage ./neo_tmedian {};
        nlm_cuda = callPackage ./nlm_cuda {};
        noise = callPackage ./noise {};
        placebo = callPackage ./placebo {};
        placebo_sgt0 = callPackage ./placebo_sgt0 {};
        raws = callPackage ./raws {};
        removedirt = callPackage ./removedirt {};
        resize2 = callPackage ./resize2 {};
        retinex = callPackage ./retinex {};
        rgvs = callPackage ./rgvs {};
        tivtc = callPackage ./tivtc {};
        tmedian = callPackage ./tmedian {};
        vivtc = callPackage ./vivtc {};
        vsnlq = callPackage ./vsnlq {};
        vszip = callPackage ./vszip {};
        webp = callPackage ./webp {};
        zscene = callPackage ./zscene {};
        zsmooth = callPackage ./zsmooth {};

        # Requires Zig nightly.
        # manipmv = callPackage ./manipmv {};
      }
      // lib.optionalAttrs config.allowAliases {
        # Aliases.
        bestsource = bs;
      })
