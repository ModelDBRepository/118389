% This function takes two complete set of input trains as inputs and a
% mixing probability.
%
% First all the spikes in the complete input set for each train is
% shuffled around.
%
% Then spikes are tagged with probability pA or (1 - pA) for inclusion
%
% Then all the tagged spikes are merged together into a new complete
% set of spikes, that is returned by the function.
%
% This 
%

function outTrain = mixTwoTrainsKeepCorr(trainA, trainB, pA)

%DEN HÄR FUNKTIONEN GÖR FEL, TESTA MED pA = 0 eller 1

pB = 1 - pA;

allSpikesA = sort(trainA(:));
allSpikesB = sort(trainB(:));

allSpikesA(find(allSpikesA == inf)) = [];
allSpikesB(find(allSpikesB == inf)) = [];

uSpikesA = unique(allSpikesA);
uSpikesB = unique(allSpikesB);

uMaskA = find(rand(size(uSpikesA)) < pA);
uMaskB = find(rand(size(uSpikesB)) < pB);

% Number the spikes, repetitions of same spike get same number

idxSpikesA = NaN*ones(size(allSpikesA));
idxSpikesA(1) = 1; tol = 1e-8;

for i=2:length(allSpikesA)
  if(abs(allSpikesA(i) - allSpikesA(i-1)) < tol)
    idxSpikesA(i) = idxSpikesA(i-1); % Same as previous spike, keep idx
  else
    idxSpikesA(i) = idxSpikesA(i-1) + 1; % Increment counter if new spike  
  end
end

% Do same for spikes in trainB

idxSpikesB = NaN*ones(size(allSpikesB));
idxSpikesB(1) = 1; tol = 1e-8;

for i=2:length(allSpikesB)
  if(abs(allSpikesB(i) - allSpikesB(i-1)) < tol)
    idxSpikesB(i) = idxSpikesB(i-1); 
  else
    idxSpikesB(i) = idxSpikesB(i-1) + 1;
  end
end

nTrains = size(trainA,2);

% Create storage for the resulting spike vectors
for i = 1:nTrains
  tSpik{i} = [];
end

% We use freeTrains to make sure that two repetitions of the same
% spike does not come in the same input train

for i = 1:length(uMaskA)
  keepSpikes = allSpikesA(find(uMaskA(i) == idxSpikesA));

  freeTrains = 1:nTrains;

  for j = 1:length(keepSpikes)
    idx = ceil(length(freeTrains)*rand(1));
    trainIdx = freeTrains(idx);
    freeTrains(idx) = [];

    tSpik{trainIdx} = [tSpik{trainIdx}; keepSpikes(j)];      
  end
end

for i = 1:length(uMaskB)
  keepSpikes = allSpikesB(find(uMaskB(i) == idxSpikesB));

  freeTrains = 1:nTrains;

  for j = 1:length(keepSpikes)
    idx = ceil(length(freeTrains)*rand(1));
    trainIdx = freeTrains(idx);
    freeTrains(idx) = [];

    tSpik{trainIdx} = [tSpik{trainIdx}; keepSpikes(j)];      
  end
end

% Convert the tSpike cell array to a matrix, pad with inf.

maxLen = 0;

for i=1:nTrains
  maxLen = max(maxLen, length(tSpik{i}));    
end

outTrain = inf*ones(maxLen, nTrains);

for i=1:nTrains
  outTrain(1:length(tSpik{i}),i) = tSpik{i}; 
end

outTrain = sort(outTrain);
