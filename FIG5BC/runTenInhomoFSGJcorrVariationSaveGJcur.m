% Sets up and runs the FS network simulation
% The neuron have different slightly randomized cell parameters
%
% This script varies the pMix variable, mixing of shared and
% individual input. There are nCells + 1 input sets, the last one is
% shared between all cells (we vary the fraction of shared inputs). 
%
% Run the script to generate data for the figures:
%
% runTenInhomoFSGJcorrVariationSaveGJcur.m
% readTenInhomoFScorrVarWithGJcur.m
% 
% To make figure 5B:
% makeTenInhomoFScorrVar.m
% 
% To make figure 5C:
% makeSpikeCenteredGJcurPlot.m
%
%
%
%

clear all, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')


nReps = 10 

corrRudolph = 0.5;
upFreq = 20/9; %10/9 
noiseFreq = 1/9;
maxTime = 10 % 100 
allowVar = 1 % 0

numCells = 10;
numGJ = 3;  % 3*10/2 = 15, 10*9/2 = 45, 15/45 = 1/3 = 33 % coupling

channelMask = {'A_channel'} % Channels to vary conductance for
cellVar = 0.5 % 0.2 % 0.1; % Fraction to vary channels, 0.5 = +/- 50%
lenVar = 0.5 % 0.2 %0.1;  % Fraction to vary compartment length by

%pMixRange = linspace(0,1,5);
pMixRange = 1 - sqrt(linspace(0,1,5));


dataFile{1} = 'TenInhomoFS-prim-AllUpstate-corrVar-saveGJcur';
dataFile{2} = 'TenInhomoFS-nonConRef-AllUpstate-corrVar-saveGJcur';


dataDir = 'UTDATA/SAVED/TenFScorrVar-saveGJcur/';

for rep=1:nReps

    disp('Pausing for 1 second, press Ctrl+C to abort')
    pause(1)    
    
    %% Generate input!

    randSeed = floor(sum(clock)*1e5);
    
    % Set random seed for making the network, obs we dont want to use 
    % same seed as for input, hence the +1000
    rand('seed', randSeed + 1000)
                       
    clear gapSrc gapDest
    [gapSrc, gapDest, conMat] = makeFSrandomNetwork(numCells,numGJ);
    % figure, showFSnetwork(conMat, randSeed)

    conMatFile = strcat([dataDir 'conMat-' num2str(randSeed)], '.mat');
    save(conMatFile, 'conMat');

    
    gapSource{1} = gapSrc;
    gapSource{2} = []; % Reference case
    gapDest{1} = gapDest;
    gapDest{2} = []; % Reference case

    gapIdNonCon = 2;
    
    % 2e9 ohm = 0.5 nS
    primGapRes = ones(length(gapSrc),1)*2e9 

    clear gapRes
    
    gapRes{1} = primGapRes;
    gapRes{2} = inf; % Reference case, unconnected

    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)
    
    for pIdx = 1:length(pMixRange)
      pMix = pMixRange(pIdx);
    
      % Generate input with pMix value
      % checkSpikeMixFunction.m har verifierat mixTwoTrainsKeepCorr.m

      correlationByDuplicationOfSpikes(corrRudolph, upFreq, noiseFreq, ...
                                       max(maxTime,100), allowVar, ...
                                       pMix, randSeed, numCells);
      
    
      for gapIdx = 1:length(gapRes)
        
        writeParameters(maxTime,numCells, ...
                        gapSource{gapIdx}, gapDest{gapIdx}, gapRes{gapIdx}, ...
                        dataFile{gapIdx});

        system('genesis ../genesisScripts/simFsMultiInhomogeneMeasureGJcurrent');

        %% Save data

        
        saveFileData = [dataDir dataFile{gapIdx} ...
                        '-id' num2str(randSeed) ...
                        '-gapres-' num2str(gapRes{gapIdx}(1)) ...
                        '-pMix-' num2str(pMix) ...
                        '.data'];
                
        saveFileInfo = strrep(saveFileData,'.data','.info');

        
        system(['cp UTDATA/' dataFile{gapIdx} '.data ' saveFileData]);
        
        system(['cp INDATA/parameters.txt ' saveFileInfo]);
        system(['cat INDATA/inputInfo.txt >> ' saveFileInfo]);

      end
    end
end


toc
