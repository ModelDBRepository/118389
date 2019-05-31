% Counts the number of spikes that has atleast nNeigh neighbour spikes
% and a time difference dT defining how far apart they are allowed to be.


function numPairs = countSpikesWithNeighbourSpike(trace,neighTrace,dT,nNeigh)

[rA,cA] = size(trace); [rB,cB] = size(neighTrace);

if(cA ~= 1 || cB ~= 1)
  disp('ERROR - countSynchSpikePairs - incorrect dimensions')
end

% Find the pair matrix
pairMat = abs(repmat(trace, 1, rB) - repmat(neighTrace', rA, 1)) < dT;

% Count the number of non-zero rows
% Those correspond to spikes having atleast one nieghbour spike within dT
numPairs = nnz(sum(pairMat,2) >= nNeigh);

