% Figure S2
%
% To run the simulation:
% runOneFSsaveAMPAGABAcond.m
%
% To generate the figures:
% plotCondFigs.m
%
%
% Save AMPA and GABA cond for one FS neuron, plot soma, prim, sec,
% dend components using the area command in matlab.

clear, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')


nReps = 1

corrRudolph = [0 0.5];
upFreq = 20/9;
noiseFreq = 1/9;
maxTime = 1
allowVar = 1 % 0

numCells = 1;


for i=1:length(corrRudolph)
  dataFile{i} = sprintf('OneFS-saveAMPAGABAcond-corrRudolph-%.2f', ...
                        corrRudolph(i));
end

for iCR = 1:length(corrRudolph)

    disp('Pausing for 1 second, press Ctrl+C to abort')
    pause(1)
    
    %% Generate input!

    randSeed = floor(sum(clock)*1e5);

    % Både upstate och downstate input
    makeAllExternalInputAllUpstate(corrRudolph(iCR), upFreq, noiseFreq, ...
                                   max(maxTime,100), allowVar, ...
                                   randSeed, numCells);

    
    gapSource = [];
    gapDest = []; 
    gapRes = inf;
        
    writeParameters(maxTime,numCells, ...
                    gapSource, gapDest, gapRes, ...
                    dataFile{iCR});

    system('genesis simFSsaveAMPAGABA');

    %% Save data
   
        system(['cp UTDATA/' dataFile{iCR} '.data UTDATA/SAVED/' ...
                dataFile{iCR} '-id' num2str(randSeed) '.data']);

        system(['cp INDATA/parameters.txt UTDATA/SAVED/' ...
                dataFile{iCR} '-id' num2str(randSeed) '.info'])
        system(['cat INDATA/inputInfo.txt >> UTDATA/SAVED/' ...
                dataFile{iCR} '-id' num2str(randSeed) '.info'])

    
end


toc
