These simulations take quite some time to finish, if you just want to
see the script running then lower the nReps and maxTime. Ofcourse,
this will remove all traces of significance from the results.

Have fun!

/Johannes



Figure 7A

In directory FIG7AB/ run the following matlab scripts

runTenInhomoFSwithShiftingCorr.m
readTenInhomoFSshiftCorr.m
makeShiftCorrPlotTEST.m

Note: You can use readTenInhomoFSshiftCorrTHROWAWAYDATA.m to read in
the data, this will throw away voltage data instead of storing them in
memory. If you have done alot of simulations, or if your computer has
limited memory this is probably the script you want to use.


Figure 7B

In directory FIG7B/ run the following matlab scripts to create the 3D
visualisation of the network.

makeNetworkVis27PrimMARKED.m



Figure 7C

In directory FIG7AC/ run the following matlab scripts

runLARGEFSwithShiftingCorr.m
read125FSshiftCorrTHROWAWAYDATA.m
makeShiftCorrPlot125FS.m






Figure 7D

In directory FIG7D/ run the following matlab scripts to create the figure

runLARGEAllUpstateOnlyPrimWrappedNGJscan.m
runLARGEAllUpstateOnlySecWrappedNGJscan.m

readLARGEnetOnlyPrimWrappedNGJ.m
plotLARGEFSNETcrossCorrelogram.m
readLARGEnetOnlySecWrappedNGJ.m
plotLARGEFSNETcrossCorrelogram.m
plotLARGEFSNETcrossCorrelogramMERGEDupdatedFig7D.m


