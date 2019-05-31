%
% Kolla upp vad xcorr gör...
%

% Tanken är att duplicera vissa spikar i spiktåg mellan närliggande
% celler för att se hur detta påverkar synkroniseringen


% allowVar = 1 --> mother/daughter generation (DEFAULT)
% allowVar = 0 --> fixed number of doubletts for all spikes train-version



function m = correlationByJittering(corrRudolph, upFreq, ...
                                    noiseFreq, maxTime, ...
                                    allowVar, jitterDt, ...
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
  
  % Input that will be jittered then fed for the neurons
  
  dupInsignalAMPA = makeDaughterNoise(corrRudolph, nAMPA, ...
                                      upFreq, maxTime);

  dupInsignalGABA = makeDaughterNoise(corrRudolph, nGABA, ...
                                      upFreq, maxTime);
else                                  
  disp('Generating input with constant number of doubletts')  

  % Input that will be jittered then fed to the neurons 
  
  dupInsignalAMPA = makeTrainNoise(corrRudolph, nAMPA, ...
                                   upFreq, maxTime);

  dupInsignalGABA = makeTrainNoise(corrRudolph, nGABA, ...
                                   upFreq, maxTime);
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

    
  % Jitter the inputs from the dup stream
                                  
  insignalAMPA = gaussJitterInputKeepCorr(dupInsignalAMPA, ...
                                          jitterDt, ...
                                          maxTime);

  insignalGABA = gaussJitterInputKeepCorr(dupInsignalGABA, ...
                                          jitterDt, ...
                                          maxTime);
                                        
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  writeInput([path 'AMPAinsignal_' num2str(nCtr) '_%d'], insignalAMPA);
  writeInput([path 'GABAinsignal_' num2str(nCtr) '_%d'], insignalGABA);

  writeInput([path 'AMPAnoise_' num2str(nCtr) '_%d'], allNoiseAMPA{nCtr});
  writeInput([path 'GABAnoise_' num2str(nCtr) '_%d'], allNoiseGABA{nCtr});

  cellNum = nCtr;
  
  noiseAMPA = allNoiseAMPA{nCtr};
  noiseGABA = allNoiseGABA{nCtr};

  eval(['save ' path 'JitterCorrInput_' num2str(nCtr) ...
              '_id' num2str(randSeed) ...
              '_jitterDt' num2str(jitterDt) '.mat' ...
          ' insignalAMPA insignalGABA ' ...
          ' noiseAMPA noiseGABA randSeed cellNum jitterDt']);
  
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen([path 'inputInfo.txt'], 'w');

fprintf(fid, '%s\n', 'correlationByJitteringOfSpikes');
fprintf(fid, '%f\n', corrRudolph);
fprintf(fid, '%f\n', upFreq);
fprintf(fid, '%f\n', noiseFreq);
fprintf(fid, '%f\n', maxTime);
fprintf(fid, '%d\n', allowVar);
fprintf(fid, '%d\n', randSeed);
fprintf(fid, '%d\n', numCells);
fprintf(fid, '%f\n', jitterDt);

fclose(fid);
