To create the figures for supplementary Figure S1 do the following:

Figure S1A is a visualisation of the network, see Figure 7B for similar code.

__________________________________________________________

Figure S1B

Firing frequency in the network as a function of the location and
number of gap junctions on each FS neuron.


This figure uses the same simulated data as Figure 7D, if that has
already been pregenerated the next run-step can be skipped.

In the directory FIGS1/ run the following scripts:

To run the simulations needed (primary and secondary
dendrites):

runLARGEAllUpstateOnlyPrimWrappedNGJscan.m
runLARGEAllUpstateOnlySecWrappedNGJscan.m


To read in and pre-parse the primary GJ simulations:

readLARGEnetOnlyPrimWrappedNGJ.m
plotLARGEFreqForNGJ.m


To read in and pre-parse the secondary GJ simulations:

readLARGEnetOnlySecWrappedNGJ.m
plotLARGEFreqForNGJ


To generate the final figure:

plotLARGEFreqForNGJMERGED.m


___________________________________________________________


Figure S1C

Input resistance (in LARGE FS network) as a function of the number of
FS gap junctions


Run the following script to generate the data:

calcInputResistance.m
calcInputResistanceSecDend.m

First parse and plot the figures:

plotInputResistance.m
plotInputResistanceSecDend.m

After the pre-parsing, a merged figure can be plotted (used in article):

plotInputResistanceMERGED.m


____________________________________________________________

Figure S1D

Cross-correlation in large FS network.

This figure uses the same simulated data as Figure 7D and S1B, if that
has already been pregenerated the next run-step can be skipped.

In the directory FIGS1/ run the following scripts:

To run the simulations needed (primary and secondary
dendrites):

runLARGEAllUpstateOnlyPrimWrappedNGJscan.m
runLARGEAllUpstateOnlySecWrappedNGJscan.m


To parse and plot the data:
readLARGEnetOnlyPrimWrappedNGJ.m
plotLARGEFSNETcrossCorrelogram.m
plotLARGEFSNETcrossCorrelogramAllToAll.m

readLARGEnetOnlySecWrappedNGJ.m
plotLARGEFSNETcrossCorrelogram.m
plotLARGEFSNETcrossCorrelogramAllToAll.m

To generate the merged figure, using the previously parsed data:

plotLARGEFSNETcrossCorrelogramMERGEDFIGS1Dcolour.m

____________________________________________________________


Figure S1E

No propagating waves in the large FS network. The figure shows the
total number of spikes triggered in neighbouring neurons as a result
of an initial spike in a neuron.

This figure uses the same simulated data as Figure 7D, S1B and S1D, if
that has already been pregenerated the next run-step can be skipped.

In the directory FIGS1/ run the following scripts:

To run the simulations needed (primary and secondary
dendrites):

runLARGEAllUpstateOnlyPrimWrappedNGJscan.m
runLARGEAllUpstateOnlySecWrappedNGJscan.m


To read and parse the data:

readLARGEnetOnlyPrimWrappedNGJ.m
calcProbTriggeringNeighSpike.m

readLARGEnetOnlySecWrappedNGJ.m
calcProbTriggeringNeighSpike.m


To create the merged figure after pre-parsing the data:

calcProbTriggeringNeighSpikeMERGED.m





