%
% Generates noise
%

function noise = makeDaughterNoise(corrRudolph, nDaughters, freq, maxTime)

  nRudolph = nDaughters - sqrt(corrRudolph)*(nDaughters-1);
  pShare = 1/nRudolph;
  
  motherSpikes = poissonMaxTime(freq*nRudolph, maxTime);
  
  len = length(motherSpikes);

  v = (rand(len, nDaughters) < pShare).*repmat(motherSpikes,1,nDaughters);
  v(find(v == 0)) = inf;
  v = sort(v,1);
  vlen = 1+max(mod(find(v < inf) - 1, len));
  noise = v(1:vlen,:);
  
  
