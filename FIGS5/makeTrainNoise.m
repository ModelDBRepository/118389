%
% Generates 2Hz square waves with 0.5 dutycycle.
%

function noise = makeTrainNoise(corrRudolph, nTrains, freq, maxTime)

  nRudolph = nTrains - sqrt(corrRudolph)*(nTrains-1);
  
  allSpikes = poissonMaxTime(freq*nRudolph, maxTime);
  
  for i=1:nTrains
    finalSpikes{i} = [];
  end
  
  for i=1:length(allSpikes)
     repeats = nTrains / nRudolph;
     repeats = floor(repeats) + (rand(1) < mod(repeats,1));

     freeTrains = 1:nTrains;
     
     for j=1:repeats
         idx = ceil(length(freeTrains)*rand(1));
         trainIdx = freeTrains(idx);
         freeTrains(idx) = [];
         
         finalSpikes{trainIdx} = [finalSpikes{trainIdx}; allSpikes(i)];
     end     
  end

  
  for i=1:nTrains
     trainLen(i) = length(finalSpikes{i}); 
  end

  maxLen = max(trainLen); 
  noise = inf*ones(maxLen,nTrains);

  for i=1:nTrains
     noise(1:length(finalSpikes{i}),i) = finalSpikes{i}; 
      
  end
  
