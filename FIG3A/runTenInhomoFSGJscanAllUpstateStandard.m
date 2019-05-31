% Sets up and runs the fsNetwork simulation
% The neuron have different slightly randomized cell parameters
%
% This file simulates 0.5nS GJ, and no gap junctions for referenses
%
% To read in and plot data:
% readTenFSAllupstateDataStandard
% makeFIG3standardCrossCorrelogramAllInOneFINER
% 

clear all, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')

nReps = 10 

runIFcurScan = 0

corrRudolph = 0.5;
upFreq = 20/9; %10/9 
noiseFreq = 1/9;
maxTime = 10 % 100 
allowVar = 1 % 0

numCells = 10;
numGJ = 3;  % 3*10/2 = 15, 10*9/2 = 45, 15/45 = 1/3 = 33 % coupling
            % numGJ = 4 ---> 44% coupling

channelMask = {'A_channel'} % Channels to vary conductance of
cellVar = 0.5 % 0.2 % 0.1; % How much to vary conductance?
lenVar = 0.5 % 0.2 %0.1; % How much to vary compartment length?

curIFrange = linspace(0,0.1e-9,10);


dataFile{1} = 'TenInhomoFS-prim-AllUpstate-GJscan';
dataFile{2} = 'TenInhomoFS-nonConRef-AllUpstate-GJscan';

dataFileCur = 'TenInhomoFS-curInject-AllUpstate-GJscan'

dataDir = 'UTDATA/SAVED/TenFSGJscanAllUpstateStandard/';

% Use this if you want to repeat a simulation, for instance if you
% later want to add more similar simulations:
%
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
      

    % Både upstate och downstate input
    makeAllExternalInputAllUpstate(corrRudolph, upFreq, noiseFreq, ...
                                   max(maxTime,100), allowVar, ...
                                   randSeed, numCells);
                       
    clear gapSrc gapDest
    [gapSrc, gapDest, conMat] = makeFSrandomNetwork(numCells,numGJ);

    % Uncomment to display topology of network that is being simulated
    %figure, showFSnetwork(conMat, randSeed) 

    conMatFile = strcat([dataDir 'conMat-' num2str(randSeed)], '.mat');
    save(conMatFile, 'conMat');

    
    gapSource{1} = gapSrc;
    gapSource{2} = []; % Reference case
    gapDest{1} = gapDest;
    gapDest{2} = []; % Reference case

    gapIdNonCon = 2;
    
    primGapRes = ones(length(gapSrc),1)*2e9 

    clear gapRes
    
    gapRes{1} = primGapRes;
    gapRes{2} = inf; % Reference case, unconnected

    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)
    

    %%% Add more runs with different gap junction resistance
    
    % No extra runs this time, only standard
    gapResExtra = [] % 1./[1e-9 0.8e-9 0.6e-9 0.4e-9];

    % Primary GJ    
    idxOffsett = length(gapRes);
    for i=[idxOffsett + (1:length(gapResExtra))]

      dataFile{i} = dataFile{1};
      gapSource{i} = gapSource{1};
      gapDest{i} = gapDest{1};
      gapRes{i} = ones(length(gapSrc),1)*gapResExtra(i-idxOffsett);

    end

    
    % Loopa through the various GJ configurations
    
    for gapIdx = 1:length(gapRes)
        

        disp('Pausing for 1 second, press Ctrl+C to abort')
        pause(1)
         
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

    
        
    % If runIFcurScan is set, then the code generates data for
    % IF-curves also.

    if(runIFcurScan)
        
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
        
        % Write current parameters to file for genesis
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
