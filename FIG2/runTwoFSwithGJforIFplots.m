% Sets up and runs the fsNetwork simulation
%
% The purpose is to generate IF plots for neurons that have neighbours
% receiving varying kinds of current inputs (depolarising/hyperpolarising)
%
% To read the data use:
% 
% readIFSscanFSpair.m
% makeIFplots.m
%
%

clear all, format compact
tic

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')

numCells = 9;

channelMask = {'A_channel'} % Lägg till fler om fler ska varieras
cellVar = 0 % 0.5 
lenVar = 0 % 0.5

curIFrange = linspace(0,0.2e-9,10);
%curIFrange = linspace(0,0.2e-9,51); % Use this for finer plot


dataFileCur = 'StandardFS-curInject-IF-altNeigh'

dataDir = 'UTDATA/SAVED/';


%% Generate input!

%randSeed = floor(sum(clock)*1e5);
randSeed = 123;

    %   0    A standpuls, unconnected
    % 1 - 2  A standard, B standard
    % 3 - 4  A standard, B svagare
    % 5 - 6  A standard, B inget input
    % 7 - 8  A standard, B hyperpolariserad
    
gapSource = {'/fs[1]/primdend1', '/fs[3]/primdend1', ...
             '/fs[5]/primdend1', '/fs[7]/primdend1'}
gapDest   = {'/fs[2]/primdend1', '/fs[4]/primdend1', ...
             '/fs[6]/primdend1', '/fs[8]/primdend1'}

% 2e9 ohm = 0.5nS
primGapRes = ones(length(gapSource),1)*2e9

clear gapRes
    
gapRes = primGapRes;

% Generera FS morphologin
    
makeFSMorph(numCells, cellVar, channelMask, lenVar)
    

    
        
maxCurTime = 2;

    
% Use shorter simulations for, obs gapIdx = 2 (ie nonConnected)
writeParameters(maxCurTime,numCells, ...
                gapSource, ...
                gapDest, ...
                gapRes, ...
                dataFileCur);        
        
for j=1:length(curIFrange)

    disp('Pausing one second')
    pause(1)
    
    %   0    A standpulser, unconnected
    % 1 - 2  A standard, B standard
    % 3 - 4  A standard, B weaker
    % 5 - 6  A standard, B no input
    % 7 - 8  A standard, B hyperpolariserad

  clear curAmp curStart curEnd curLoc   
    
  for k=1:numCells
    
    curStart{k} = 0;
    curEnd{k} = maxCurTime + 1;
    curLoc{k} = sprintf('/fs[%d]/soma', k-1);
   
  end
 
  curAmp{1} = curIFrange(j); % A
  curAmp{2} = curIFrange(j); % A
  curAmp{3} = curIFrange(j); % B
  curAmp{4} = curIFrange(j); % A
  curAmp{5} = curIFrange(j)/2; % B
  curAmp{6} = curIFrange(j); % A
  curAmp{7} = 0; % B
  curAmp{8} = curIFrange(j); % A
  curAmp{9} = -curIFrange(j); % B
  
  
  % Skriv ströminjektionsinfo till fil...
  writeCurrentInputInfo(curStart, curEnd, curAmp, curLoc)

  % This one ignores all synaptic input
  system('genesis ../genesisScripts/simFsMultiInhomogeneCurrentInjection');
      
  saveFileData = [dataDir dataFileCur ...
                  '-ID' num2str(randSeed) ...
                  '-gapres-' num2str(gapRes(1)) ...
                  '-cur-' num2str(curIFrange(j)) ...
                  '.data'];
                
  saveFileInfo = strrep(saveFileData,'.data','.info');

        
  system(['cp UTDATA/' dataFileCur '.data ' saveFileData]);
        
  system(['cp INDATA/parameters.txt ' saveFileInfo]);
  system(['cat INDATA/currentInputInfo.txt >> ' saveFileInfo]);
  
end

%% Add code to generate figures here

toc
