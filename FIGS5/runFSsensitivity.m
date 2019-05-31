%
% The purpose of this code is to inspect the sensitivity of the main
% results due to changes in channel conductance, and time constants.
%
% 1. How is the frequency changed?
% 2. How is the shunting changed?
% 3. How is the synchronisation changed?
%
% To check this we run a genesis script which allows us to modify the
% channel parameters. The model has four FS neurons, A1, A2, B1, B2.
%
% A1 and A2 are identical, but their channel parameters can be
% modified (both neurons always have the same set of parameters)
% B1 and B2 are identical. their channel parameters are at default values
% A1 and B1 are coupled by gap junctions, A2 and B2 are uncoupled.
% 
% Neuron number: A1 = #1, A2 = #2, B1 = #3, B2 = #4
%
%

clear all, format compact

tic

% Seed the random numbers by the clock

randId = floor(sum(1e5*clock));
s = RandStream.create('mt19937ar','seed',randId);
RandStream.setDefaultStream(s);

FSpars = [1 1 1 1 1 1 1 1 1 1];

parFile = 'FSparameters.info';
outputFile = 'FSoutput';

% Random seed for FS input
randSeed = floor(1e5*rand);

maxTime = 2 %20;
numCells = 4;

corrRudolph = 0.5;
upFreq = 4; 
noiseFreq = 0.11;
allowVar = 1;

% In this simulation we only use numCells/2 input sets, this is
% because each connected neuron has an unconnected reference neuron.

makeAllSynapticInput(corrRudolph, upFreq, noiseFreq, ...
                     maxTime, allowVar, ...
                     randSeed, numCells/2);

% Indexes of MOD:ed cells, and of those with original channels
cellModIdx  = 1:2:numCells;                 
cellOrigIdx = 2:2:numCells;

% Generera FS morphologin
channelMask = {}; % All identical
cellVar = 0;
lenVar = 0;

% First parameter is index of neurons to write p-file for
makeFSMorphMOD(cellModIdx, cellVar, channelMask, lenVar)
makeFSMorph(cellOrigIdx, cellVar, channelMask, lenVar)

% Gap junction info

gapSource = {'/fs[0]/primdend1'};
gapDest   = {'/fs[2]/primdend1'};
gapRes = 2e9; % 0.5nS

writeFSMODinfo(parFile, outputFile, maxTime, numCells, ...
               gapSource, gapDest, gapRes, ...
               FSpars, cellModIdx);

% Run simulation
system(sprintf('nice genesis simFourFSsaveGJcur %s', parFile));

toc









