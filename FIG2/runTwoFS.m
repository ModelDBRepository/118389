% Sets up and runs the fsNetwork simulation
%
% This version only runs two neurons, and has no variation in
% compartment length or in KA conductance.
%
% 
% To generate Figure 2C
%
% runTwoFS.m
% readTwoFS.m
% makeTwoFS2dSynchSpikeFreqPlotFIG2Cprop.m
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

numCells = 2;
numGJ = 1;

channelMask = {'A_channel'} % Channels to vary
cellVar = 0 % 0.5 
lenVar = 0 % 0.5

flagRunIFplots = 0
curIFrange = linspace(0,0.1e-9,10);


dataFile{1} = 'TenInhomoFS-prim-AllUpstate-GJscan';
dataFile{2} = 'TenInhomoFS-nonConRef-AllUpstate-GJscan';

dataFileCur = 'TenInhomoFS-curInject-AllUpstate-GJscan'

dataDir = 'UTDATA/SAVED/';

for rep=1:nReps
    disp('Pausing one second')
    pause(1)
    
    %% Generate input!

    randSeed = floor(sum(clock)*1e5);

    % Upstate input
    makeAllExternalInputAllUpstate(corrRudolph, upFreq, noiseFreq, ...
                                   max(maxTime,100), allowVar, ...
                                   randSeed, numCells);
                       
    clear gapSrc gapDest
    [gapSrc, gapDest, conMat] = makeFSrandomNetwork(numCells,numGJ);
    
    % Uncomment to display network
    %figure, showFSnetwork(conMat, randSeed)

    conMatFile = strcat([dataDir 'conMat-' num2str(randSeed)], '.mat');
    save(conMatFile, 'conMat');

    
    gapSource{1} = gapSrc;
    gapSource{2} = []; % Reference case
    gapDest{1} = gapDest;
    gapDest{2} = []; % Reference case

    gapIdNonCon = 2;
    
    % 2e9 ohm = 0.5nS
    primGapRes = ones(length(gapSrc),1)*2e9

    clear gapRes
    
    gapRes{1} = primGapRes;
    gapRes{2} = inf; % Reference case, unconnected

    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)
    

    %%% Add more runs with different gap junction resistance
    
    gapResExtra = 1./(1e-9* [1 0.9 0.8 0.7 0.6 0.4 0.3 0.2 0.1])
    %gapResExtra = 1e9
    
    % Primary GJ    
    idxOffsett = length(gapRes);
    for i=[idxOffsett + (1:length(gapResExtra))]

      dataFile{i} = dataFile{1};
      gapSource{i} = gapSource{1};
      gapDest{i} = gapDest{1};
      gapRes{i} = ones(length(gapSrc),1)*gapResExtra(i-idxOffsett);

    end

    
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

    
        
    % Generate IF-curves for the neurons

    if(flagRunIFplots)
        
      maxCurTime = 1;

      % Use shorter simulations for, obs gapIdx = 2 (ie nonConnected)
      writeParameters(maxCurTime,numCells, ...
                      gapSource{gapIdNonCon}, ...
                      gapDest{gapIdNonCon}, ...
                      gapRes{gapIdNonCon}, ...
                      dataFileCur);        
        
      for j=1:length(curIFrange)
            
        for k=1:numCells
    
          curStart{k} = 0;
          curEnd{k} = maxCurTime + 1;
          curAmp{k} = curIFrange(j);
          curLoc{k} = sprintf('/fs[%d]/soma', k-1);
   
        end
        
        % Skriv ströminjektionsinfo till fil...
        writeCurrentInputInfo(curStart, curEnd, curAmp, curLoc)

        % This one ignores all synaptic input
        system('genesis ../genesisScripts/simFsMultiInhomogeneCurrentInjection');
      
        saveFileData = [dataDir dataFileCur ...
                        '-ID' num2str(randSeed) ...
                        '-gapres-' num2str(gapRes{gapIdNonCon}(1)) ...
                        '-cur-' num2str(curIFrange(j)) ...
                        '.data'];
                
        saveFileInfo = strrep(saveFileData,'.data','.info');

        
        system(['cp UTDATA/' dataFileCur '.data ' saveFileData]);
        
        system(['cp INDATA/parameters.txt ' saveFileInfo]);
        system(['cat INDATA/inputInfo.txt >> ' saveFileInfo]);
        system(['cat INDATA/currentInputInfo.txt >> ' saveFileInfo]);
  
    end
  end  
end

%% Add code to generate figures here

toc
