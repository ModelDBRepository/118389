function matrix = makeJPST(spikeTimesA, spikeTimesB, maxTime)

ticsPerSecond = 1e4;
dutyCycle = 0.5;
baseFreq = 2;
period = 1/baseFreq;


periodTics = period*ticsPerSecond;
maxTics = maxTime*ticsPerSecond;

matrix = sparse(periodTics, periodTics);
       
cellAspikes = spikeTimesA*ticsPerSecond;
cellBspikes = spikeTimesB*ticsPerSecond;
        
idxA = ceil(mod(cellAspikes, periodTics));
idxB = ceil(mod(cellBspikes, periodTics));

% 0 <= t < ticsPerSecond belongs to first bin
% ceil takes care of all but t = 0
idxA(find(idxA == 0)) = 1;
idxB(find(idxB == 0)) = 1;

periodIdxA = ceil(cellAspikes / periodTics);
periodIdxB = ceil(cellBspikes / periodTics);
        
for pIdx = unique(periodIdxA)'
    spIdxA = find(periodIdxA == pIdx);
    spIdxB = find(periodIdxB == pIdx);
    
    if(~isempty(spIdxA) & ~isempty(spIdxB))
        matrix(idxA(spIdxA), idxB(spIdxB)) = ...
            matrix(idxA(spIdxA), idxB(spIdxB)) + 1;
    end
end
    

