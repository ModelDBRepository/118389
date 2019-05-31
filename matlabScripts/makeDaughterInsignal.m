%
% Generates 2Hz square waves with 0.5 dutycycle.
%

function insignal = makeDaughterInsignal(corrRudolph, nDaughters, ...
                                      upFreq, downFreq, maxTime)

  nRudolph = nDaughters - sqrt(corrRudolph)*(nDaughters-1);
  pShare = 1/nRudolph;
  
  baseFreq = 2;
  dutyCycle = 0.5;
  
  stateTime = dutyCycle/baseFreq;
  isUpstate = 1; % Start with upstate
  startTime = 0;
  
  motherSpikes = [];
  
  for startTime = 0:stateTime:(maxTime-stateTime)
      if(isUpstate)
          curFreq = upFreq*nRudolph;          
      else
          curFreq = downFreq*nRudolph;          
      end
      
      motherSpikes = [motherSpikes; ...
                      startTime + poissonMaxTime(curFreq, stateTime)];
      
      isUpstate = ~isUpstate;
  end
  
  len = length(motherSpikes);

  v = (rand(len, nDaughters) < pShare).*repmat(motherSpikes,1,nDaughters);
  v(find(v == 0)) = inf;
  v = sort(v);
  vlen = 1+max(mod(find(v < inf) - 1, len));
  insignal = v(1:vlen,:);
  
  
