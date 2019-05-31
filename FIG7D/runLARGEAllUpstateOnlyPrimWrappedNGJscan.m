%
% To generate figure 7D, run the following MATLAB scripts
%
% runLARGEAllUpstateOnlyPrimWrappedNGJscan.m
% runLARGEAllUpstateOnlySecWrappedNGJscan.m
%
% readLARGEnetOnlyPrimWrappedNGJ.m
% plotLARGEFSNETcrossCorrelogram.m
%
% readLARGEnetOnlySecWrappedNGJ.m
% plotLARGEFSNETcrossCorrelogram.m
%
% plotLARGEFSNETcrossCorrelogramMERGEDupdatedFig7D.m
%
%%%%%%%%%
%
% This data is also used in Figure S1B
%
% readLARGEnetOnlyPrimWrappedNGJ.m
% plotLARGEFreqForNGJ.m
%
% readLARGEnetOnlySecWrappedNGJ.m
% plotLARGEFreqForNGJ.m
%
% plotLARGEFreqForNGJMERGED.m
%
%%%%%%%%%
%
% As well as Figure S1D
%
% To parse and plot the data:
% readLARGEnetOnlyPrimWrappedNGJ.m
% plotLARGEFSNETcrossCorrelogram.m
% plotLARGEFSNETcrossCorrelogramAllToAll.m
% 
% readLARGEnetOnlySecWrappedNGJ.m
% plotLARGEFSNETcrossCorrelogram.m
% plotLARGEFSNETcrossCorrelogramAllToAll.m
% 
% To generate the merged figure, using the previously parsed data:
% 
% plotLARGEFSNETcrossCorrelogramMERGEDFIGS1Dcolour.m
%
%%%%%%%%
%
% And also figure S1E
%
% To read and parse the data:
%
% readLARGEnetOnlyPrimWrappedNGJ.m
% calcProbTriggeringNeighSpike.m
% 
% readLARGEnetOnlySecWrappedNGJ.m
% calcProbTriggeringNeighSpike.m
% 
%
% To create the merged figure after pre-parsing the data:
% 
% calcProbTriggeringNeighSpikeMERGED.m
%
%


clear all, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')


nReps = 1 %10  

corrRudolph = 0.5;
upFreq = 20/9; %10/9 
noiseFreq = 1/9;
maxTime = 10 % 100 
allowVar = 1 % 0

nWidth = 5;
numCells = nWidth^3;

nGJmax = 16;

channelMask = {'A_channel'} % Lägg till fler om fler ska varieras
cellVar = 0.5 % 0.2 % 0.1;
lenVar = 0.5 % 0.2 %0.1;


dataFile{1} = 'LARGEInhomoFS-nonConRef-Wrapped-AllUpstate-NGJscan';

for i=1:nGJmax
  dataFile{i+1} = 'LARGEInhomoFS-prim-Wrapped-AllUpstate-NGJscan';
end

dataDir = 'UTDATA/SAVED/LARGEFSGJAllUpstateOnlyPrimWrappedNGJscan/';

%randSeedVec = [207679982 208875585 210303368 210409172 210947077 ...
%               211436238 211604930 212952301 214734880 215311625];

randSeedVec = [];
       

for rep=1:nReps

    disp('Pausing for 1 second, press Ctrl+C to abort')
    pause(1)
    
    %% Generate input!

    if(rep > length(randSeedVec))
      disp('Adding new randSeed')
      randSeed = floor(sum(clock)*1e5);
      randSeedVec(rep) = randSeed;
    else
      disp('Using saved randSeed')    
      randSeed = randSeedVec(rep);
    end
      
    makeAllExternalInputAllUpstate(corrRudolph, upFreq, noiseFreq, ...
                                   maxTime, allowVar, ...
                                   randSeed, numCells);
                       
    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)

    clear gapSource gapDest gapRes
    
    gapSource{1} = []; % Reference case
    gapDest{1} = []; % Reference case
    gapIdNonCon = 1;
    gapRes{1} = inf; % Reference case, unconnected
    avgNGap(1) = 0;
    
    for i=1:ceil(nGJmax/2)
        
        % The code will round up the number of average GJ per neuron
        % to even 2:s. This is because each GJ appear twice in the
        % simulation, on different neurons. This is a simplification
        % in the code.
        nGJ = i*2;
                               
        [gapSrc, gapDes, conMat] = ...
          makeFSconnectionMatrixOnlyPrimWrappedSetNGJ(nWidth,nWidth,nWidth,nGJ);

        conMatFile = sprintf('%sconMat-avgNGap%d-randSeed%d.mat', ...
                             dataDir, nGJ, randSeed);

        save(conMatFile, 'conMat');

        primGapRes = ones(length(gapSrc),1)*2e9; 
    
        gapSource{i+1} = gapSrc;
        gapDest{i+1} = gapDes;
        gapRes{i+1} = primGapRes;
        avgNGap(i+1) = nGJ;
    end

    
    %keyboard
    
    % Loopa nGJmax+1 varv för olika antal GJ
    
    for gapIdx = 1:length(gapRes)
     
        disp('Pausing for 2 seconds')
        pause(2)
        
        writeParameters(maxTime,numCells, ...
                        gapSource{gapIdx}, gapDest{gapIdx}, gapRes{gapIdx}, ...
                        dataFile{gapIdx});

        system('genesis ../genesisScripts/simFsMultiInhomogene');

        %% Save data

        
        saveFileData = [dataDir dataFile{gapIdx} ...
                        '-id' num2str(randSeed) ...
                        '-avgNGap-' num2str(avgNGap(gapIdx)) ...
                        '-gapres-' num2str(gapRes{gapIdx}(1)) ...
                        '.data'];
                
        saveFileInfo = strrep(saveFileData,'.data','.info');

        
        system(['cp UTDATA/' dataFile{gapIdx} '.data ' saveFileData]);
        
        system(['cp INDATA/parameters.txt ' saveFileInfo]);
        system(['cat INDATA/inputInfo.txt >> ' saveFileInfo]);

    end

end

%% Add code to generate figures here

toc
