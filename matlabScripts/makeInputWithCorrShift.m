%
% This function generates upstate input, with varying jittering
%
% periodLen(1) = time A
% periodLen(2)= time B
% periodLen(3) = time C
% ...
% corrFlag(1) = is input 100% correlated or uncorrelated
% 
% allowVar = 1 --> mother/daughter generation (DEFAULT)
% allowVar = 0 --> fixed number of doubletts for all spikes train-version



function makeInputWithCorrShift(periodLen, corrFlag, ...
                                corrRudolph, upFreq, ...
                                noiseFreq, maxTime, ...
                                allowVar, ...
                                randSeed, numCells)
                                
rand('seed', randSeed)
randSeed = rand('seed');

disp(['Setting random seed to ' num2str(randSeed)])

path = [pwd '/INDATA/'];


nAMPA = 127;
nGABA = 93;

downFreq = 1e-9;

disp(['All upstate input with varying corr, freq ' num2str(upFreq)])

t = 0;

for i=1:numCells
  allInsignalAMPA{i} = [];
end
  
while(t < maxTime)
  for tIdx = 1:length(periodLen)
    
    for i=1:numCells
        
      % Regenerate input for each cell only if corrFlag = 0
      % If corrFlag = 1 we just need to generate one set of inputs
      if(i == 1 | ~corrFlag(tIdx))
        if(allowVar)
          periodAMPA = makeDaughterNoise(corrRudolph, nAMPA, upFreq, ...
                                         periodLen(tIdx));
        else
          periodAMPA = makeTrainNoise(corrRudolph, nAMPA, upFreq, ...
                                      periodLen(tIdx));
        end
      end                         
  
      allInsignalAMPA{i} = [allInsignalAMPA{i}; t + periodAMPA];
    
    end
      
    t = t + periodLen(tIdx);
  end
end

for i=1:numCells
%  allInsignalAMPA{i}(isnan(allInsignalAMPA{i})) = inf;
  allInsignalAMPA{i}(allInsignalAMPA{i} > maxTime) = inf;
  allInsignalAMPA{i} = sort(allInsignalAMPA{i},1);
end

for nCtr = 1:numCells
    
  % Generate uncorrelated noise
    
  if(allowVar)
    allNoiseAMPA{nCtr} = makeDaughterNoise(corrRudolph, nAMPA, ...
                                           noiseFreq, maxTime);
    allNoiseGABA{nCtr} = makeDaughterNoise(corrRudolph, nGABA, ...
                                           noiseFreq, maxTime); 
    allInsignalGABA{nCtr} = makeDaughterNoise(corrRudolph, nGABA, ...
                                              upFreq, maxTime);
                                          
  else
    allNoiseAMPA{nCtr} = makeTrainNoise(corrRudolph, nAMPA, ...
                                        noiseFreq, maxTime);
    allNoiseGABA{nCtr} = makeTrainNoise(corrRudolph, nGABA, ...
                                        noiseFreq, maxTime);  
    allInsignalGABA{nCtr} = makeTrainNoise(corrRudolph, nGABA, ...
                                           upFreq, maxTime);  
  end

end

%plot(mod(allInsignalAMPA{1},0.5), allInsignalAMPA{1} - allInsignalAMPA{2},'.')


for nCtr = 1:numCells

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
  writeInput([path 'AMPAinsignal_' num2str(nCtr) '_%d'],allInsignalAMPA{nCtr});
  writeInput([path 'GABAinsignal_' num2str(nCtr) '_%d'],allInsignalGABA{nCtr});

  writeInput([path 'AMPAnoise_' num2str(nCtr) '_%d'], allNoiseAMPA{nCtr});
  writeInput([path 'GABAnoise_' num2str(nCtr) '_%d'], allNoiseGABA{nCtr});

  cellNum = nCtr;
  
  noiseAMPA = allNoiseAMPA{nCtr};
  noiseGABA = allNoiseGABA{nCtr};

  insignalAMPA = allInsignalAMPA{nCtr};
  insignalGABA = allInsignalGABA{nCtr};
  
  eval(['save ' path 'CorrFlagInput_' num2str(nCtr) ...
              '_id' num2str(randSeed) '.mat' ...
          ' insignalAMPA insignalGABA ' ...
          ' noiseAMPA noiseGABA randSeed cellNum periodLen corrFlag']);
  
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen([path 'inputInfo.txt'], 'w');

fprintf(fid, '%s\n', 'correlation shifting (corrFlag)');
fprintf(fid, '%f\n', corrRudolph);
fprintf(fid, '%f\n', upFreq);
fprintf(fid, '%f\n', noiseFreq);
fprintf(fid, '%f\n', maxTime);
fprintf(fid, '%d\n', allowVar);
fprintf(fid, '%d\n', randSeed);
fprintf(fid, '%d\n', numCells);
fprintf(fid, '%d\n', length(periodLen)); % Number of period shifts

for i=1:length(periodLen)
  fprintf(fid, '%f\n', periodLen(i));
  fprintf(fid, '%f\n', corrFlag(i));
end
fclose(fid);
