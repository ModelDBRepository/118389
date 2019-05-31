%
% This version of the file only calculates the IF plots
% (It is a reduced version of the full script which uses current
% injection instead of synaptic inputs)
%
% 
% To generate Figure 1A run the following MATLAB scripts:
%
% runIFscanTenFS.m
% readIFscanTenFS.m
% makeIFplots.m
%

clear all, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')


nReps = 1 % 10 
nPoints = 20;

maxTime = 10;
numCells = 30;

channelMask = {'A_channel'} % Channel conductances we want to vary
cellVar = 0.5 % 0.2 % 0.1;
lenVar = 0.5 % 0.2 %0.1;

curIFrange = linspace(0,0.1e-9,nPoints);

dataFileCur = 'TenInhomoFS-curInject-IFscan'

dataDir = 'UTDATA/SAVED/TenFSIFscanHighRES/';

for rep=1:nReps

    disp('Pausing for 1 second, press Ctrl+C to abort')
    pause(1)    
    
    %% Generate input! First, seed...
    randSeed = floor(sum(clock)*1e5);

    % Generera FS morphologin
    
    makeFSMorph(numCells, cellVar, channelMask, lenVar)
    
    % Overwrite first cell morphology with the standard cell
    makeFSMorph(1, 0, channelMask, 0)

    maxCurTime = maxTime;
    
    % No gap junctions
    writeParameters(maxCurTime,numCells,[],[],[],dataFileCur);        
        
    for j=1:length(curIFrange)
            
      for k=1:numCells
    
        curStart{k} = 0;
        curEnd{k} = maxCurTime + 1;
        curAmp{k} = curIFrange(j);
        curLoc{k} = sprintf('/fs[%d]/soma', k-1);
   
      end
        
      % Write parameters to file
      writeCurrentInputInfo(curStart, curEnd, curAmp, curLoc)

      % This one ignores all synaptic input
      system('genesis ../genesisScripts/simFsMultiInhomogeneCurrentInjection');
      
      saveFileData = [dataDir dataFileCur ...
                      '-ID' num2str(randSeed) ...
                      '-cur-' num2str(curIFrange(j)) ...
                      '.data'];
                
      saveFileInfo = strrep(saveFileData,'.data','.info');

        
      system(['cp UTDATA/' dataFileCur '.data ' saveFileData]);
        
      system(['cp INDATA/parameters.txt ' saveFileInfo]);
      system(['cat INDATA/currentInputInfo.txt >> ' saveFileInfo]);
  
    end
end

%% Add code to generate figures here

toc
