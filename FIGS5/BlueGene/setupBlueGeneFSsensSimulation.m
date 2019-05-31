% This matlab script crates all the files necessary to run on BlueGene
%
%

clear all, close all, format compact
tic

path([pwd '/../'], path)

numNodes = 128;
numBatches = 3;
numSims = floor(numBatches*numNodes*2/21);

% Seed the random numbers by the clock

randId = floor(sum(1e5*clock));
s = RandStream.create('mt19937ar','seed',randId);
RandStream.setDefaultStream(s);

% How much to vary the parameters?
dPar = 0.20;

FSpars = [ones(1,10); ...
          ones(10,10) + dPar*diag(ones(10,1)); ...
          ones(10,10) - dPar*diag(ones(10,1))];


fileMask = {'TenFSsensitivity-ID%d-freq-%.1fHz-ref%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gNa-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gKA-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gK3132-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gK13-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mNaTau-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-hNaTau-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mKATau-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-hKATau-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mK3132-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mK13-up%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gNa-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gKA-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gK3132-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-gK13-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mNaTau-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-hNaTau-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mKATau-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-hKATau-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mK3132-down%s', ...
            'TenFSsensitivity-ID%d-freq-%.1fHz-mK13-down%s'};


maxTime = 10 
numCells = 20;
numGJ = 3;  % 3*10/2 = 15, 10*9/2 = 45, 15/45 = 1/3 = 33 % coupling
            % numGJ = 4 ---> 44% coupling

corrRudolph = 0.5;
upFreqList = [4];
noiseFreq = 0.11;
allowVar = 1;

% Indexes of MOD:ed cells, and of those with original channels
% In this version all cells are modified according to FSpars
% parameters, however these lines gives us the option to just modify
% some of the neurons (and then cellOrigIdx and makeFSmorph lines
% below have to be uncommented.

cellModIdx  = 1:numCells; % 1:2:numCells;

%cellOrigIdx = 2:2:numCells;

% Generera FS morphologin
channelMask = {}; % All identical
cellVar = 0;
lenVar = 0;

% First parameter is index of neurons to write p-file for
makeFSMorphMOD(cellModIdx, cellVar, channelMask, lenVar)
%makeFSMorph(cellOrigIdx, cellVar, channelMask, lenVar)

% Gap junction info

[gapSrc, gapDest, conMat] = makeFSrandomNetwork(0:2:(numCells-1),numGJ);
gapRes = 2e9*ones(size(gapSrc)); % 0.5nS

save(sprintf('INDATA/connectionMatrix-ID%d.mat',randId),'conMat');

parFileList = {};

for iSims = 1:numSims

  % Random seed for FS input
  randSeed = floor(1e5*rand);

  % In this simulation we only use numCells/2 input sets, this is
  % because each connected neuron has an unconnected reference neuron.

  for j=1:length(upFreqList)

    upFreq = upFreqList(j);

    INDATApath = sprintf('INDATA-ID%d',randSeed);
    
    makeAllSynapticInputParallell(corrRudolph, upFreq, noiseFreq, ...
                                  maxTime, allowVar, ...
                                  randSeed, numCells/2, INDATApath);

    for i=1:size(FSpars,1)

      parFile = sprintf(fileMask{i},randSeed,upFreq,'.info');
      outputFile = sprintf(fileMask{i},randSeed,upFreq,'');

      writeFSMODinfoParallell(parFile, outputFile, maxTime, numCells, ...
                              gapSrc, gapDest, gapRes, ...
                              FSpars(i,:), cellModIdx,INDATApath);

      parFileList{end+1} = parFile;
    end
                      
  end

end


%%%%%% Create information about the job


% Mask needs numNodes and simBatch
jcfMask = ...
['# Running Sobol sensitivity analysis\n'                         ...
 '#\n'                                                            ...
 '# @ job_name            = TenFS\n'       ...
 '# @ job_type            = bluegene\n'                           ...
 '# @ comment             = "hjorth@nada.kth.se"\n'               ...
 '# @ error               = TenFS-%d.$(job_name).$(jobid).err\n'   ...
 '# @ output              = TenFS-%d.$(job_name).$(jobid).out\n'   ...
 '# @ environment         = COPY_ALL;\n'                          ...
 '# @ wall_clock_limit    = 08:00:00,08:00:00\n'                  ...
 '# @ notification        = always\n'                             ...
 '# @ notify_user         = hjorth@nada.kth.se\n'                 ...
 '# @ bg_size             = %d\n'                                 ...
 '# @ bg_connection       = mesh\n'                               ...
 '# @ class               = large\n'                              ...
 '# @ queue\n\n'                                                  ...
 'mpirun -np %d -mode VN -cwd /gpfs/scratch/h/hjorth/SensitivityFS ' ...
 '-verbose 2 '  ...
 './nxpgenesis -notty -altsimrc ./startup/bgl/.nxpsimrc '         ...
 'simFSsaveGJcurParallell.g %d\n'];

jcfNameMask = 'batchScripts/runBatch%d';


for i=1:numBatches
  fid = fopen(sprintf(jcfNameMask,i),'w');
  if(i < numBatches)
    fprintf(fid,jcfMask,i,i,numNodes,numNodes*2,i);
  else
    procLeft = length(parFileList)-(numBatches-1)*2*numNodes;
    if(mod(procLeft,2) == 1)
      disp('WARNING UNEVEN NUMBER OF JOBBS!!')
    end

    fprintf(fid,jcfMask,i,i,ceil(procLeft/2),procLeft,i);

  end
  fclose(fid);
end


batchId = kron(1:numBatches,ones(1,2*numNodes));
batchId = batchId(1:length(parFileList));

% This should not really be called nodeId but rather procId
nodeId = mod(0:(length(parFileList)-1),2*numNodes);

if(length(unique(batchId*1e5+nodeId)) < length(parFileList))
  disp('Numbering error!!!')
  return
end

for i=1:length(parFileList)
  fid = fopen(sprintf('nodeScripts/run-Batch%d-Node%d', ...
                         batchId(i), nodeId(i)),'w');

  fprintf(fid, parFileList{i});

  fclose(fid);

end


fid = fopen('batchScripts/runALL','w');
for i=1:numBatches
  fprintf(fid,'llsubmit runBatch%d\n',i);
end
fclose(fid);
system('chmod u+x batchScripts/runALL');




toc
