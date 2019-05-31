% Sets up and runs the fsNetwork simulation
% The neuron have different slightly randomized cell parameters
%
%
% To generate Figure 7C
%
% runLARGEFSwithShiftingCorr.m
% read125FSshiftCorrTHROWAWAYDATA.m
% makeShiftCorrPlot125FS.m
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
allowVar = 1 % 0

nWidth = 5;
numCells = nWidth^3;

nGJmax = 16;

channelMask = {'A_channel'} % Lägg till fler om fler ska varieras
cellVar = 0.5 % 0.2 % 0.1;
lenVar = 0.5 % 0.2 %0.1;

periodLen = [480e-3 20e-3];
corrFlag = [0 1];

dataFile{1} = 'LARGEInhomoFS-nonConRef-Wrapped-AllUpstate-NGJscan';

for i=1:nGJmax
  dataFile{i+1} = 'LARGEInhomoFS-prim-Wrapped-AllUpstate-NGJscan';
end

dataDir = 'UTDATA/SAVED/LARGEFS-shiftingCorrFlag-saveGJcur/';

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
      

    % Only upstate input, but with varying jittering
    makeInputWithCorrShift125center(periodLen, corrFlag, ...
                                    corrRudolph, upFreq, noiseFreq, ...
                                    max(maxTime,100), allowVar, ...
                                    randSeed, numCells);
                       

    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)

    clear gapSource gapDest gapRes
    
    gapSource{1} = []; % Reference case
    gapDest{1} = []; % Reference case
    gapIdNonCon = 1;
    gapRes{1} = inf; % Reference case, unconnected
    avgNGap(1) = 0;
    
    % !!! TEMP FIX, WE ONLY RUN ref case and 6 gap junctions case
    for i=3 %1:ceil(nGJmax/2)
        
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
    
        gapSource{end+1} = gapSrc;
        gapDest{end+1} = gapDes;
        gapRes{end+1} = primGapRes;
        avgNGap(end+1) = nGJ;
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
