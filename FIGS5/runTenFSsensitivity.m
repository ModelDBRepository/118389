%
% To generate the supplementary figures S5:
%
% S5A
% runTenFSsensitivity.m
% readTenFSsensitivity
% makeShuntingSensitivityFigure.m
% 
%
% S5B
% runTenFSsensitivity.m     (same as in S5A)
% readTenFSsensitivity.m
% makeCorrPairFigure.m
%
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

%FSpars = [1 1 1 1 1 1 1 1 1 1];
%parFile = 'TenFSparameters.info';
%outputFile = 'TenFSoutput';

dPar = 0.05;

FSpars = [ones(1,10); ...
          ones(10,10) + dPar*diag(ones(10,1)); ...
          ones(10,10) - dPar*diag(ones(10,1))];

fileMask = {'TenFSsensitivity-ID%d-freq-%.1fHz-ref%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gNa-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gKA-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gK3132-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gK13-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mNaTau-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-hNaTau-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mKATau-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-hKATau-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mK3132-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mK13-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gNa-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gKA-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gK3132-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gK13-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mNaTau-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-hNaTau-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mKATau-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-hKATau-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mK3132-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mK13-down%s'};
      
       
maxTime = 10 % 0.5 %10;
numCells = 20;
numGJ = 3;  % 3*10/2 = 15, 10*9/2 = 45, 15/45 = 1/3 = 33 % coupling
            % numGJ = 4 ---> 44% coupling

corrRudolph = 0.5;
upFreqList = [4]; 
noiseFreq = 0.11;
allowVar = 1;

% Indexes of MOD:ed cells, and of those with original channels
cellModIdx  = 1:numCells; % 1:2:numCells;                 
%cellOrigIdx = 2:2:numCells;

% Generera FS morphologin
channelMask = {}; % All identical
cellVar = 0;
lenVar = 0;

% First parameter is index of neurons to write p-file for
makeFSMorphMOD(cellModIdx, cellVar, channelMask, lenVar)
%makeFSMorph(cellOrigIdx, cellVar, channelMask, lenVar)

% Gap junction info

[gapSrc, gapDest, conMat] = makeFSrandomNetwork(0:2:(numCells-1),numGJ);
gapRes = 2e9*ones(size(gapSrc)); % 0.5nS

save(sprintf('INDATA/connectionMatrix-ID%d.mat',randId),'conMat');

matlabpool

% Random seed for FS input
randSeed = floor(1e5*rand);

% In this simulation we only use numCells/2 input sets, this is
% because each connected neuron has an unconnected reference neuron.

for j=1:length(upFreqList)

  disp('Pausing for 1 second, press Ctrl+C to abort')
  pause(1)  
    
  upFreq = upFreqList(j);

  makeAllSynapticInput(corrRudolph, upFreq, noiseFreq, ...
                       maxTime, allowVar, ...
                       randSeed, numCells/2);

  parfor i=1:size(FSpars,1)

    parFile = sprintf(fileMask{i},randId,upFreq,'.info');
    outputFile = sprintf(fileMask{i},randId,upFreq,'');

    writeFSMODinfo(parFile, outputFile, maxTime, numCells, ...
                   gapSrc, gapDest, gapRes, ...
                   FSpars(i,:), cellModIdx);

    % Run simulation
    system(sprintf('nice genesis simFourFSsaveGJcur %s', parFile));

  end

end
  
matlabpool close

toc









