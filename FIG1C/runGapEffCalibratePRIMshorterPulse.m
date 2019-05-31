%
% This script runs and generates Figure 1C.
%
% Here we use a current injection to trigger a spike, then a pulse depol.
%

clear, format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')


nPoints = 11

numCells = 2;
dataFile = 'FSGapEffCalibratePrimShorterPulse';
refDataFile = 'FSGapEffRef';

masterTarget  = '/fs[0]/soma';
slaveTarget   = '/fs[1]/soma';
masterFile    = 'INDATA/masterTrain.data';
slaveFile     = 'INDATA/slaveTrain.data'
refMasterFile = 'INDATA/refMasterTrain.data';
refSlaveFile  = 'INDATA/refSlaveTrain.data';

%% Gap junctions

refGap = [];

gapSource{1} = '/fs[0]/primdend1';
gapDest{1} = '/fs[1]/primdend1';


%%  Write indata spikes to file
%%
%%  We want a spike to the master neuron at 1.0s and none to slave neuron

masterTrain = [pwd '/' masterFile];
slaveTrain  = [pwd '/' slaveFile];

masterData = [0.01];
slaveData = [];

dlmwrite(masterTrain, masterData,'delimiter',  '\n', 'precision','%.6f');
dlmwrite(slaveTrain, slaveData,'delimiter', '\n', 'precision','%.6f');



%% Current pulses
%%
%%

pulseStart = [1 2.0]
pulseEnd = [1.001 3]
pulseCurrent = [0.2e-9 0.01e-9]; %[0.40e-9];
pulseLoc{1} = '/fs[0]/soma';
pulseLoc{2} = '/fs[0]/soma';
maxTime = 4.0

disp('The current pulse leads to a spike... too large')


% If we want the reference for nonconnected case to get input
% resistance then include inf.
gapResRange = [inf 1./linspace(10e-10,1e-12,nPoints)];
%gapResRange = 1./linspace(1e-12,10e-10,nPoints);


for gapResIdx = 1:length(gapResRange)

    disp('Pausing for 1 second, press Ctrl+C to abort')
    pause(1)
    
    gapRes = ones(1,1)*gapResRange(gapResIdx);
    
    if(gapRes == inf)
        writeParameters(maxTime,numCells, masterTarget, slaveTarget, ...
                        [], [], [], ...
                        dataFile, masterFile, slaveFile, ...
                        pulseStart, pulseEnd, pulseCurrent, pulseLoc);

    else        

      writeParameters(maxTime,numCells, masterTarget, slaveTarget, ...
                      gapSource, gapDest, gapRes, ...
                      dataFile, masterFile, slaveFile, ...
                      pulseStart, pulseEnd, pulseCurrent, pulseLoc);

    end
       
    disp('Sleeping for 1 second')
    pause(1)
    
    system('genesis simFsGapEffCalibrate');

    system(['cp UTDATA/' dataFile '.data UTDATA/SAVED/ShorterPules/' dataFile '-gapres-' num2str(gapRes(1)) '.data']);

    system(['cp INDATA/parameters.txt UTDATA/SAVED/ShorterPules/' dataFile '-gapres-' num2str(gapRes(1)) '.info'])
end


[grs, ccs, scs] = makeGapCalibrateFigureCond('UTDATA/SAVED/ShorterPules/', ...
                       'FSGapEffCalibratePrimShorterPulse-gapres-*.data', ...
                       0.5, [0.9 1.2], [1.9 3.1])
    
