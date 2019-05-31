%
% For supplementary material figure S4A
%
% Cur inject -- freq figure
% /home/hjorth/genesis/fsCurInputInhomogeneNetwork
%
%
% runTenFScurInejctInhomogeneNetworkGJscan.m
% readTenFSGJscanInjectCur.m
% makeTenFS3dGJscanPlotcurInject.m
%
% or
%
% makeTenFSGJscanPlotCurInject
%
%
%
% The purpose of this piece of code is to see if shunting is less
% when we are dealing with current injections rather than synaptic
% input. My hypothesis here is that if we have synaptic input the
% neighbouring cells will not be at the same excitation level and they
% will shunt away to less excited neighbours when they get input.
%
% With a current injection we have a much more even distribution of
% inputs over time, so the neighbouring neurons should not shunt as
% much to their less excited neighbours since there are no such as
% they all get injected currents.
%
% Ten FS neurons, slightly randomized cell properties, varies GJ conductance.

clear, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')


nReps = 1 %10 % 2 % 10 

maxTime = 20 % 1 % 10 % 100 

numCells = 10;
numGJ = 3;  % 3*10/2 = 15, 10*9/2 = 45, 15/45 = 1/3 = 33 % coupling
            % numGJ = 4 ---> 44% coupling

channelMask = {'A_channel'} % Lägg till fler om fler ska varieras
cellVar = 0.5 % 0.1;
lenVar = 0.5 %0.1;

curInject = 0.5075e-10

dataFile{1} = 'TenInhomoFS-prim-CurInject-GJscan';
dataFile{2} = 'TenInhomoFS-nonConRef-CurInject-GJscan';

dataDir = 'UTDATA/SAVED/TenFSGJscanCurInject/';


for rep=1:nReps

    disp('Pausing 1 second')
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
    gapDest{1} = gapDestFS;
    gapDest{2} = []; % Reference case

    gapIdNonCon = 2;
 
    
    % 4.4e9 ohm = 0.227nS = 6.87% coupling
%    primGapRes = ones(length(gapSrcFS),1)*4.4e9
    primGapRes = ones(length(gapSrcFS),1)*2e9

    % Try with 1nS just to see if it works
    %primGapRes = ones(length(gapSrcFS),1)*(1/1e-9)

    clear gapRes

    gapRes{1} = primGapRes;
    gapRes{2} = inf; % Reference case, unconnected

    %%% Add more runs with different gap junction resistance

%    gapResExtra = [1e9 3e9 5e9 10e9 1e8 1e7];
%    gapResExtra = 1./[1e-9 0.8e-9 0.6e-9 0.4e-9 0.2e-9];
    gapResExtra = 1./linspace(1e-9,0.1e-9,10);
    
    % Primary GJ
    idxOffsett = length(gapRes);
    for i=[idxOffsett + (1:length(gapResExtra))]

      dataFile{i} = dataFile{1};
      gapSource{i} = gapSource{1};
      gapDest{i} = gapDest{1};
      gapRes{i} = ones(length(gapSrcFS),1)*gapResExtra(i-idxOffsett);

    end
   
    
    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)
    
    

    % Loopa två varv, ett för prim och ett för okopplat (+ för extra)
    
    for gapIdx = 1:length(gapRes)

        disp('Pausing 1 second')
        pause(1)
        
        writeParameters(maxTime,numCells, ...
                        gapSource{gapIdx}, ...
                        gapDest{gapIdx}, ...
                        gapRes{gapIdx}, ...
                        dataFile{gapIdx});

        clear curStart curEnd curAmp curLoc            
                    
        for k=1:numCells

          curStart{k} = 0;
          curEnd{k} = maxTime + 1;
          curAmp{k} = curInject;
          curLoc{k} = sprintf('/fs[%d]/soma', k-1);

        end
                    
                    
                    
        % Skriv ströminjektionsinfo till fil...
        writeCurrentInputInfo(curStart, curEnd, curAmp, curLoc)
                    
        % This one ignores all synaptic input
        system('genesis ../genesisScripts/simFsMultiInhomogeneCurrentInjection');
 
        
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
