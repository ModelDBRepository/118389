%
% Kolla upp vad xcorr gör...
%

% Tanken är att duplicera vissa spikar i spiktåg mellan närliggande
% celler för att se hur detta påverkar synkroniseringen


% allowVar = 1 --> mother/daughter generation (DEFAULT)
% allowVar = 0 --> fixed number of doubletts for all spikes train-version



function m = correlationByDuplicationOfSpikes(corrRudolph, upFreq, ...
                                              noiseFreq, maxTime, ...
                                              allowVar, pMix, ...
                                              randSeed, numCells)

                                  
rand('seed', randSeed)
randSeed = rand('seed');

disp(['Setting random seed to ' num2str(randSeed)])

path = [pwd '/INDATA/'];


nAMPA = 127;
nGABA = 93;

downFreq = 1e-9;

disp(['All upstate input, freq ' num2str(upFreq)])


if(allowVar)
  disp('Generating mother/daughter input')
  
  % Input that is duplicated in several input traces
  
  dupInsignalAMPA = makeDaughterNoise(corrRudolph, nAMPA, ...
                                      upFreq, maxTime);

  dupInsignalGABA = makeDaughterNoise(corrRudolph, nGABA, ...
                                      upFreq, maxTime);
 
  for nCtr = 1:numCells

    % Generate input to neurons that are correlated within the neuron
    % but not correlated between neurons. This input is then mixed
    % with the population shared input.

    % Neuron specific input
  
    uniqueInsignalAMPA{nCtr} = makeDaughterNoise(corrRudolph, nAMPA, ...
                                                 upFreq, maxTime);

    uniqueInsignalGABA{nCtr} = makeDaughterNoise(corrRudolph, nGABA, ...
                                                 upFreq, maxTime);
  end

else                                  
  disp('Generating input with constant number of doubletts')  

  % Input that is duplicated in several input traces 
  
  dupInsignalAMPA = makeTrainNoise(corrRudolph, nAMPA, ...
                                   upFreq, maxTime);

  dupInsignalGABA = makeTrainNoise(corrRudolph, nGABA, ...
                                   upFreq, maxTime);

  for nCtr = 1:numCells

    % Generate input to neurons that are correlated within the neuron
    % but not correlated between neurons. This input is then mixed
    % with the population shared input.

    % Neuron specific input
  
    uniqueInsignalAMPA{nCtr} = makeTrainNoise(corrRudolph, nAMPA, ...
                                            upFreq, maxTime);

    uniqueInsignalGABA{nCtr} = makeTrainNoise(corrRudolph, nGABA, ...
                                            upFreq, maxTime);
  end
                                                        
end

for nCtr = 1:numCells
    
  % Generate uncorrelated noise
    
  if(allowVar)
    allNoiseAMPA{nCtr} = makeDaughterNoise(corrRudolph, nAMPA, ...
                                        noiseFreq, maxTime);
    allNoiseGABA{nCtr} = makeDaughterNoise(corrRudolph, nGABA, ...
                                        noiseFreq, maxTime); 
  else
    allNoiseAMPA{nCtr} = makeTrainNoise(corrRudolph, nAMPA, ...
                                        noiseFreq, maxTime);
    allNoiseGABA{nCtr} = makeTrainNoise(corrRudolph, nGABA, ...
                                        noiseFreq, maxTime);  
  end

end



for nCtr = 1:numCells

  % Mix the duplicate and unique input                                  
  % pMix = 0, only duplicate train
  % pMix = 1, only unique train
                                  
  insignalAMPA = mixTwoTrainsKeepCorr(uniqueInsignalAMPA{nCtr}, ...
                                      dupInsignalAMPA, pMix);
  insignalGABA = mixTwoTrainsKeepCorr(uniqueInsignalGABA{nCtr}, ...
                                      dupInsignalGABA, pMix);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  writeInput([path 'AMPAinsignal_' num2str(nCtr) '_%d'], insignalAMPA);
  writeInput([path 'GABAinsignal_' num2str(nCtr) '_%d'], insignalGABA);

  writeInput([path 'AMPAnoise_' num2str(nCtr) '_%d'], allNoiseAMPA{nCtr});
  writeInput([path 'GABAnoise_' num2str(nCtr) '_%d'], allNoiseGABA{nCtr});

  cellNum = nCtr;
  
  noiseAMPA = allNoiseAMPA{nCtr};
  noiseGABA = allNoiseGABA{nCtr};

  eval(['save ' path 'DuplicationCorrInput_' num2str(nCtr) ...
              '_id' num2str(randSeed) ...
              '_pMix' num2str(pMix) '.mat' ...
          ' insignalAMPA insignalGABA ' ...
          ' noiseAMPA noiseGABA randSeed cellNum pMix']);
  
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen([path 'inputInfo.txt'], 'w');

fprintf(fid, '%s\n', 'correlationByDuplicationOfSpikes');
fprintf(fid, '%f\n', corrRudolph);
fprintf(fid, '%f\n', upFreq);
fprintf(fid, '%f\n', noiseFreq);
fprintf(fid, '%f\n', maxTime);
fprintf(fid, '%d\n', allowVar);
fprintf(fid, '%d\n', randSeed);
fprintf(fid, '%d\n', numCells);
fprintf(fid, '%f\n', pMix);

fclose(fid);
