% This code runs ten FS neurons, starting without gap junctions, which
% then shows no synchronisation between the neurons, when the gap
% junctions are added the neurons rapidly synchronises.
%
% The neurons are driven by current injection.
%
% To view the traces use;  compareTraces.m

clear, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')


nReps = 1  % 2 % 10 

maxTime = 0.75 % 10 % 100 

numCells = 10;
numGJ = 3;  % 3*10/2 = 15, 10*9/2 = 45, 15/45 = 1/3 = 33 % coupling
            % numGJ = 4 ---> 44% coupling

channelMask = {'A_channel'} % Channels to vary
cellVar = 0 % 0.5 % 0.1;
lenVar = 0 % 0.5 %0.1;

curInject = linspace(0.555e-10,0.65e-10,numCells);

dataFile{1} = 'TenHomoFS-prim-CurInject-GJonoff';
dataFile{2} = 'TenHomoFS-nonConRef-CurInject-GJonoff';
dataFile{3} = 'TenHomoFS-prim-CurInject-GJonoff';

dataDir = 'UTDATA/SAVED/TenHomoFSGJonoffCurInject/';


for rep=1:nReps

    disp('Pausing for 1 second, press Ctrl+C to abort')
    pause(1)
    
    %% Generate input!

    randSeed = floor(sum(clock)*1e5);

    %% Gap junctions
    
    clear gapSrcFS gapDestFS
    [gapSrcFS, gapDestFS, conMat] = makeFSrandomNetwork(numCells,numGJ);
    figure, showFSnetwork(conMat, randSeed)

    conMatFile = strcat([dataDir 'conMat-' num2str(randSeed)], '.mat');
    save(conMatFile, 'conMat');


    gapSource{1} = gapSrcFS;
    gapSource{2} = []; % Reference case
    gapSource{3} = gapSrcFS;

    gapDest{1} = gapDestFS;
    gapDest{2} = []; % Reference case
    gapDest{3} = gapDestFS;

    gapIdNonCon = 2;
 
    
    % 2e9 = 0.5nS
    primGapRes = ones(length(gapSrcFS),1)*2e9

    % Try with 1nS just to see if it works
    %primGapRes = ones(length(gapSrcFS),1)*(1/1e-9)

    clear gapRes

    gapRes{1} = primGapRes;
    gapRes{2} = inf; % Reference case, unconnected
    gapRes{3} = ones(length(gapSrcFS),1)*1e9;

    %%% Add more runs with different gap junction resistance

%    gapResExtra = 1./[1e-9 0.8e-9 0.6e-9 0.4e-9];
%
%    % Primary GJ
%    idxOffsett = length(gapRes);
%    for i=[idxOffsett + (1:length(gapResExtra))]
%
%      dataFile{i} = dataFile{1};
%      gapSource{i} = gapSource{1};
%      gapDest{i} = gapDest{1};
%      gapRes{i} = ones(length(gapSrcFS),1)*gapResExtra(i-idxOffsett);
%
%    end
   
    
    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)
    
    

    % Loopa två varv, ett för prim och ett för okopplat (+ för extra)
    
    for gapIdx = 1:length(gapRes)
        
        writeParameters(maxTime,numCells, ...
                        gapSource{gapIdx}, ...
                        gapDest{gapIdx}, ...
                        gapRes{gapIdx}, ...
                        dataFile{gapIdx});

        clear curStart curEnd curAmp curLoc            
                    
        for k=1:numCells

          curStart{k} = 0;
          curEnd{k} = maxTime + 1;
          curAmp{k} = curInject(k);
          curLoc{k} = sprintf('/fs[%d]/soma', k-1);

        end
                    
                    
                    
        % Skriv ströminjektionsinfo till fil...
        writeCurrentInputInfo(curStart, curEnd, curAmp, curLoc)
                    
        % This one ignores all synaptic input
        system('genesis simFsMultiInhomogeneCurrentInjectionGJonoff');
 
        
        %% Save data

        
        saveFileData = [dataDir dataFile{gapIdx} ...
                        '-id' num2str(randSeed) ...
                        '-gapres-' num2str(gapRes{gapIdx}(1)) ...
                        '-curamp-' num2str(curAmp{1}) ...
                        '.data'];
                
        saveFileInfo = strrep(saveFileData,'.data','.info');

        
        system(['cp UTDATA/' dataFile{gapIdx} '.data ' saveFileData]);
        
        system(['cp INDATA/parameters.txt ' saveFileInfo]);
        system(['cat INDATA/currentInputInfo.txt >> ' saveFileInfo]);

        
    end
                
end

%% Add code to generate figures here

toc
