% Figure S3
%
% Run the following matlab scripts:
% 
% Run simulations:
% runTenInhomoFSGJcorrVariationJITTERSaveGJcur.m
% 
% Read data:
% readTenInhomoFSJITTERWithGJcur.m
%
% Make the frequency curves:
% makeTenInhomoFScorrVarJITTER.m
%
% Make current through GJ figs:
% makeSpikeCenteredGJcurPlotJITTER.m
%
%
% Sets up and runs the fsNetwork simulation
% The neuron have different slightly randomized cell parameters
%
% This script varies the jitter variable
%

clear all, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')


nReps = 10 % 10 

corrRudolph = 0.5;
upFreq = 20/9; %10/9 
noiseFreq = 1/9;
maxTime = 10 % 100 
allowVar = 1 % 0 % 1 = random duplications of spikes, 0 = fixed # duplicates

numCells = 10;
numGJ = 3;  % 3*10/2 = 15, 10*9/2 = 45, 15/45 = 1/3 = 33 % coupling
            % numGJ = 4 ---> 44% coupling

channelMask = {'A_channel'} % Channel conductances to vary
cellVar = 0.5 % 0.2 % 0.1;  % Amount to vary channel conductance
lenVar = 0.5 % 0.2 %0.1;    % Amount to vary compartment length

jitterDtRange = 1e-3*[0 1 2 5 10 20]; %linspace(0,20e-3,5);


dataFile{1} = 'TenInhomoFS-prim-AllUpstate-corrVarJITTER-saveGJcur';
dataFile{2} = 'TenInhomoFS-nonConRef-AllUpstate-corrVarJITTER-saveGJcur';


dataDir = 'UTDATA/SAVED/TenFScorrVarJITTER-saveGJcur/';

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
    figure, showFSnetwork(conMat, randSeed)

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
    
    for jIdx = 1:length(jitterDtRange)
      jitterDt = jitterDtRange(jIdx);
    
      % Generate input with jitterDt value
      % checkSpikeMixFunction.m har verifierat mixTwoTrainsKeepCorr.m

      % Jittered input
      correlationByJitteringOfSpikes(corrRudolph, upFreq, noiseFreq, ...
                                     max(maxTime,100), allowVar, ...
                                     jitterDt, randSeed, numCells);
      
    
      for gapIdx = 1:length(gapRes)
        
        writeParameters(maxTime,numCells, ...
                        gapSource{gapIdx}, gapDest{gapIdx}, gapRes{gapIdx}, ...
                        dataFile{gapIdx});

        system('genesis ../genesisScripts/simFsMultiInhomogeneMeasureGJcurrent');

        %% Save data

        
        saveFileData = [dataDir dataFile{gapIdx} ...
                        '-id' num2str(randSeed) ...
                        '-gapres-' num2str(gapRes{gapIdx}(1)) ...
                        '-jitterDt-' num2str(jitterDt) ...
                        '.data'];
                
        saveFileInfo = strrep(saveFileData,'.data','.info');

        
        system(['cp UTDATA/' dataFile{gapIdx} '.data ' saveFileData]);
        
        system(['cp INDATA/parameters.txt ' saveFileInfo]);
        system(['cat INDATA/inputInfo.txt >> ' saveFileInfo]);

      end
    end
end

toc
