To generate the supplementary figures S5, go to the FIGS5 directory.

S5A
runTenFSsensitivity.m

readTenFSsensitivity
makeShuntingSensitivityFigure.m

TenFS-sense-meanFreq-updated-selection.eps



S5B
runTenFSsensitivity.m

readTenFSsensitivity.m
makeCorrPairFigure.m




For those interrested, there are also some scripts to run the
sensitivity analysis on Blue Gene using pgenesis in the
FIGS5/BlueGene/ directory. All simulations can be done using the
runTenFSsensitivy.m with regular genesis.

Prepare for the Blue Gene simulation:
setupBlueGeneFSsensSimulation.m

Copy this file to the regular FIGS5 directory on Blue Gene:
simFSsaveGJcurParallell.g

Copy all the INDATA* directories to the FIGS5 directory on Blue Gene

To clean up:
cleanBlueGene

