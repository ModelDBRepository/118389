To generate figure 5A, which uses the same base-code as Figure 2, go
into the FIG2 directory and run the matlab scripts:

runTwoFSwithGJforIFplots.m
readIFSscanFSpair.m
makeIFplots.m

FS-IFplot-effect-of-neighbour-input.eps


________________________

In the FIG5BC directory, run the following matlab scripts to generate
data for fig 5B and 5C.

If you just want to see it run, then make sure to lower nReps and
maxTime, or you will have to be *very* patient. You might also want to
modify the pMixRange by lowering 5 to 3.

runTenInhomoFSGJcorrVariationSaveGJcur
readTenInhomoFScorrVarWithGJcur

To make figure 5B:
makeTenInhomoFScorrVar

To make figure 5C:
makeSpikeCenteredGJcurPlot


_________________________


To generate figure 5D, go to FIG5D directory.


To run simulation:
runTenFScurInjectHomogeneNetworkGJonoff.m

Run
compareTraces.m

When asked for a file, input:

'UTDATA/SAVED/TenHomoFSGJonoffCurInject/TenHomoFS-prim-CurInject-GJonoff-id210991775-gapres-2000000compareTraces'

Obs, you might have to replace the randomId in idXXXXXXXXXX with your number.

