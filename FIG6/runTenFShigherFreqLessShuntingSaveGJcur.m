% Sets up and runs the fsNetwork simulation
% The neuron have different slightly randomized cell parameters
%
% This code is to test if higher input frequency means a relative
% lower decrease of firing frequency due to gap junctions
%
% This code also saves data so the gap junction current can be extracted.
% 
% Figure 6B:
% runTenFShigherFreqLessShuntingSaveGJcur.m
% readHigherFreqLessShuntingDataSavedGJcur.m
% makeGJvoltageDiffPlot.m
%
%
% Figure 6C:
% runTenFShigherFreqLessShuntingSaveGJcur.m   (same as in 6B)
% readHigherFreqLessShuntingDataSavedGJcur.m
% makeSpikeCenteredGJcurPlot.m
% makeSpikeCenteredGJcurPlotLONGER.m
%


clear all, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')

nReps = 2 

corrRudolph = 0.5;

upFreqVector = [10/9 20/9 40/9 80/9] %linspace(1,10,10);
%upFreq = 20/9; %10/9 
noiseFreq = 1/9;
maxTime = 10 % 100 
allowVar = 1 % 0

numCells = 10;
numGJ = 3;  % 3*10/2 = 15, 10*9/2 = 45, 15/45 = 1/3 = 33 % coupling
            % numGJ = 4 ---> 44% coupling

channelMask = {'A_channel'} 
cellVar = 0.5 % 0.2 % 0.1;
lenVar = 0.5 % 0.2 %0.1;



dataFile{1} = 'TenInhomoFS-prim-AllUpstate-HigherFreqLessShunt-saveGJcur';
dataFile{2} = 'TenInhomoFS-nonConRef-AllUpstate-HigherFreqLessShunt-saveGJcur';


dataDir = 'UTDATA/SAVED/TenFS-higherFreqLessShunt-saveGJcur/';

for rep=1:nReps

  disp('Pausing for 1 second, press Ctrl+C to abort')
  pause(1)  
    
  randSeed = floor(sum(clock)*1e5);

  % Generate network connections
  clear gapSrc gapDest
  [gapSrc, gapDest, conMat] = makeFSrandomNetwork(numCells,numGJ);
  %  figure, showFSnetwork(conMat, randSeed)

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

  % Generate input!
    
  for freqIdx = 1:length(upFreqVector)
    upFreq = upFreqVector(freqIdx);
    

    % Only upstate input
    makeAllExternalInputAllUpstate(corrRudolph, upFreq, noiseFreq, ...
                                   max(maxTime,100), allowVar, ...
                                   randSeed, numCells);

    
    
    
    for gapIdx = 1:length(gapRes)

      disp('Pausing for 1 second, press Ctrl+C to abort')
      pause(1)  
        
        
      writeParameters(maxTime,numCells, ...
                      gapSource{gapIdx}, gapDest{gapIdx}, gapRes{gapIdx}, ...
                      dataFile{gapIdx});

                       
                    
                    
      system('genesis ../genesisScripts/simFsMultiInhomogeneMeasureGJcurrent');

      %% Save data
        
      saveFileData = [dataDir dataFile{gapIdx} ...
                      '-id' num2str(randSeed) ...
                      '-gapres-' num2str(gapRes{gapIdx}(1)) ...
                      '-upFreq-' num2str(upFreq) ...
                      '.data'];
                
      saveFileInfo = strrep(saveFileData,'.data','.info');

        
      system(['cp UTDATA/' dataFile{gapIdx} '.data ' saveFileData]);
        
      system(['cp INDATA/parameters.txt ' saveFileInfo]);
      system(['cat INDATA/inputInfo.txt >> ' saveFileInfo]);

    end
  end    
end


toc
