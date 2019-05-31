% This code calculates the input resistance for a FS neuron in a
% population, where each neuron has nAvgGJ number of gap junctions.
%
%
% Run the following script to generate the data:
%
% calcInputResistance.m
% calcInputResistanceSecDend.m
% 
% First parse and plot the figures:
% 
% plotInputResistance.m
% plotInputResistanceSecDend.m
% 
% After the pre-parsing, a merged figure can be plotted (used in article):
% 
% plotInputResistanceMERGED.m
%
% 

clear all, close all
format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')


nWidth = 5 %2 %5;
numCells = nWidth^3;

pulseDelay = 0.200
pulseDur = 0.200;

nMeasure = 5 %2 %10

nGJvec = 0:2:16; % Number of GJ to check
cellIdx = randperm(numCells)-1;
cellIdx = cellIdx(1:nMeasure); % Use ten random selected neurons

maxTime = (pulseDelay + pulseDur)*length(cellIdx) + pulseDelay;


channelMask = {'A_channel'} % Lägg till fler om fler ska varieras
cellVar = 0.5 % 0.2 % 0.1;
lenVar = 0.5 % 0.2 %0.1;

dataFileMask = 'FSinputResCheck-avgGJ-%d-randSeed-%d.data';

dataDir = 'UTDATA/SAVED/LARGEinputResCheck/';

makeFSMorph(numCells, cellVar, channelMask, lenVar)

randSeed = floor(sum(clock)*1e5);


for iGJ=1:length(nGJvec)
    
  disp('Pausing for 3 seconds')
  pause(3)
    
  nGJ = nGJvec(iGJ);

  clear gapSource gapDest gapRes

  % nGJ should be even number
  if(nGJ == 0)
    gapSource = []; % Reference case
    gapDest = []; % Reference case
    gapRes = inf; % Reference case, unconnected
  else  
    [gapSource, gapDest, conMat] = ...
        makeFSconnectionMatrixOnlyPrimWrappedSetNGJ(nWidth,nWidth,nWidth,nGJ);  
    gapRes = ones(length(gapSource),1)*2e9;
    
    conMatFile = sprintf('%sconMat-avgNGap-%d-randSeed-%d.mat', ...
                         dataDir, nGJ, randSeed);

    save(conMatFile, 'conMat');
    
  end

  
  dataFile = sprintf(dataFileMask, nGJ, randSeed);
  dataFileGenesis = strrep(dataFile,'.data','');

  
  writeParameters(maxTime,numCells,gapSource,gapDest,gapRes,dataFileGenesis);
    
  for iCell = 1:length(cellIdx)
    curStart{iCell} = pulseDelay*iCell + (iCell-1)*pulseDur;
    curEnd{iCell} = curStart{iCell} + pulseDur;
    curAmp{iCell} = 10e-12; %5e-12;
    curLoc{iCell} = sprintf('/fs[%d]/soma', cellIdx(iCell));
  end
  
  writeCurrentInputInfo(curStart, curEnd, curAmp, curLoc)

  system('genesis ../genesisScripts/simFsMultiInhomogeneCurrentInjection');
  
  infoFile = strrep(dataFile,'.data','.info');
  system(sprintf('cp INDATA/parameters.txt UTDATA/%s', infoFile));
  system(sprintf('cat INDATA/currentInputInfo.txt >> UTDATA/%s', infoFile));

  system(sprintf('mv UTDATA/%s %s', dataFile, dataDir));  
  system(sprintf('mv UTDATA/%s %s', infoFile, dataDir));


end


toc
