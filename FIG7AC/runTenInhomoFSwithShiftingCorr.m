% Sets up and runs the fsNetwork simulation
% The neuron have different slightly randomized cell parameters
%
% This script varies the correlation between neurons
%
%
% To generate Figure 7A 
%
% runTenInhomoFSwithShiftingCorr.m
% readTenInhomoFSshiftCorr.m
% makeShiftCorrPlotTEST.m
% 
% Note: You can use readTenInhomoFSshiftCorrTHROWAWAYDATA.m to read in
% the data, this will throw away voltage data instead of storing them in
% memory. If you have done alot of simulations, or if your computer has
% limited memory this is probably the script you want to use.
%
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

numCells = 10;
numGJ = 3;  % 3*10/2 = 15, 10*9/2 = 45, 15/45 = 1/3 = 33 % coupling
            % numGJ = 4 ---> 44% coupling

channelMask = {'A_channel'} % Channel conductances to vary
cellVar = 0.5 % 0.2 % 0.1;  % Amount to vary conductance by
lenVar = 0.5 % 0.2 %0.1;    % Amount to vary compartment size by


periodLen = [480e-3 20e-3];
corrFlag = [0 1];



dataFile{1} = 'TenInhomoFS-prim-AllUpstate-shiftingCorrFlag-saveGJcur';
dataFile{2} = 'TenInhomoFS-nonConRef-AllUpstate-shiftingCorrFlag-saveGJcur';


dataDir = 'UTDATA/SAVED/TenFS-shiftingCorrFlag-saveGJcur/';

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
    %figure, showFSnetwork(conMat, randSeed)

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
    
    
    % Only upstate input, but with varying correlation
    makeInputWithCorrShift(periodLen, corrFlag, ...
                           corrRudolph, upFreq, noiseFreq, ...
                           max(maxTime,100), allowVar, randSeed, numCells);
                                
      
    % Loopa två varv, ett för prim och ett för okopplat
    
    for gapIdx = 1:length(gapRes)
      
      writeParameters(maxTime,numCells, ...
                      gapSource{gapIdx}, gapDest{gapIdx}, gapRes{gapIdx}, ...
                      dataFile{gapIdx});

      disp('Sleeping for 3 seconds')
      pause(3)
                  
      system('genesis ../genesisScripts/simFsMultiInhomogeneMeasureGJcurrent');

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


toc
