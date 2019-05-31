% Sets up and runs the fsNetwork simulation
%
% This version only runs two neurons, and has no variation in
% compartment length or in KA conductance.
%
% To read the data use:
% readTwoFSdata.m

clear all, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')

disp('This will take time...')
nReps = 100 % 10 

corrRudolph = 0.5;
upFreq = 20/9; %10/9 
noiseFreq = 1/9;
maxTime = 10 % 100 
allowVar = 1 % 0

numCells = 2;
numGJ = 1;

channelMask = {'A_channel'} % Lägg till fler om fler ska varieras
cellVar = 0 % 0.5 
lenVar = 0 % 0.5



dataFile{1} = 'TenInhomoFS-prim-upstateDownstate-GJscan';
dataFile{2} = 'TenInhomoFS-nonConRef-upstateDownstate-GJscan';
% dataFile{3} = 'TenInhomoFS-tert-AllUpstate-GJscan';


dataDir = 'UTDATA/SAVED/upstateDownstate/';

for rep=1:nReps

    disp('Pausing for 1 second, press Ctrl+C to abort')
    pause(1)
    
    %% Generate input!

    randSeed = floor(sum(clock)*1e5);


    % Både upstate och downstate input
    makeAllExternalInput(corrRudolph, upFreq, noiseFreq, ...
                         max(maxTime,100), allowVar, ...
                         randSeed, numCells);
                       
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
    
    % 4.4e9 ohm = 0.227nS = 6.87% coupling
    % primGapRes = ones(length(gapSrc),1)*4.4e9

    % 2e9 ohm = 0.5nS
    primGapRes = ones(length(gapSrc),1)*2e9

    clear gapRes
    
    gapRes{1} = primGapRes;
    gapRes{2} = inf; % Reference case, unconnected

    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)
        
    
    
    for gapIdx = 1:length(gapRes)
        
        writeParameters(maxTime,numCells, ...
                        gapSource{gapIdx}, gapDest{gapIdx}, gapRes{gapIdx}, ...
                        dataFile{gapIdx});

        system('genesis ../genesisScripts/simFsMultiInhomogene');

        %% Save data

        
        saveFileData = [dataDir dataFile{gapIdx} ...
                        '-id' num2str(randSeed) ...
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
