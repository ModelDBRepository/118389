% Sets up and runs the fsNetwork simulation
% The neuron have different slightly randomized cell parameters
%
% This version of the file varies the gap junction conductances
%
% readTenFSGJscanAllUpstate
% makeFIG3spikePairs
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

channelMask = {'A_channel'} % Channels to vary
cellVar = 0.5 % 0.2 % 0.1;  % Amount to vary channel conductance
lenVar = 0.5 % 0.2 %0.1;    % Amount to vary compartment length (0.5 = +/-50%)

curIFrange = linspace(0,0.1e-9,10);

dataFile{1} = 'TenInhomoFS-prim-AllUpstate-GJscan';
dataFile{2} = 'TenInhomoFS-nonConRef-AllUpstate-GJscan';

dataFileCur = 'TenInhomoFS-curInject-AllUpstate-GJscan'

dataDir = 'UTDATA/SAVED/TenFSGJscanAllUpstate/';

for rep=1:nReps

    disp('Pausing for 1 second, press Ctrl+C to abort')
    pause(1)    
    
    %% Generate input!

    randSeed = floor(sum(clock)*1e5);


    % Både upstate och downstate input
    makeAllExternalInputAllUpstate(corrRudolph, upFreq, noiseFreq, ...
                                   max(maxTime,100), allowVar, ...
                                   randSeed, numCells);
                       
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
    
    primGapRes = ones(length(gapSrc),1)*4.4e9 

    clear gapRes
    
    gapRes{1} = primGapRes;
    gapRes{2} = inf; % Reference case, unconnected

    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)
    

    %%% Add more runs with different gap junction resistance
    
    gapResExtra = 1./[1e-9 0.8e-9 0.6e-9 0.4e-9];

    % Primary GJ    
    idxOffsett = length(gapRes);
    for i=[idxOffsett + (1:length(gapResExtra))]

      dataFile{i} = dataFile{1};
      gapSource{i} = gapSource{1};
      gapDest{i} = gapDest{1};
      gapRes{i} = ones(length(gapSrc),1)*gapResExtra(i-idxOffsett);

    end

    % Loop through the various GJ conductances
    
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

    
        
    % Code below generates IF-curves for the neurons
        
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
        
      % Write current paramters to file
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


toc
