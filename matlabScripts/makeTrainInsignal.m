%
% Generates 2Hz square waves with 0.5 dutycycle.
%

function insignal = makeTrainInsignal(corrRudolph, nTrains, ...
                                      upFreq, downFreq, maxTime)

  nRudolph = nTrains - sqrt(corrRudolph)*(nTrains-1);

  baseFreq = 2;
  dutyCycle = 0.5;
  
  stateTime = dutyCycle/baseFreq;
  
  
  for i=1:nRudolph

    isUpstate = 1; % Start with upstate
    startTime = 0;

    trainSpikes{i} = [];
    
    for startTime = 0:stateTime:(maxTime-stateTime)

      if(isUpstate)
          curFreq = upFreq;          
      else
          curFreq = downFreq;          
      end
      
      trainSpikes{i} = [trainSpikes{i}; ...
                        startTime + poissonMaxTime(curFreq, stateTime)];
      
      isUpstate = ~isUpstate;
      
    end          
         
  end
  
  allSpikes = [];
  
  for i=1:nRudolph
      allSpikes = [allSpikes; trainSpikes{i}];
  end
  
  % Sortera spikarna!
  allSpikes = sort(allSpikes);
  
  disp('total antal spikar     unika')
  [length(allSpikes) length(unique(allSpikes))]

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
  insignal = inf*ones(maxLen,nTrains);

  for i=1:nTrains
     insignal(1:length(finalSpikes{i}),i) = finalSpikes{i}; 
      
  end
  
