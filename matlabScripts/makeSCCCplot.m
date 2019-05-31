% savedSpikesTimes# = cell array with cell arrays with spike times
% runIdx# = index into first cell array, which runs to use
% cellIdx# = index into second cell array, which two cells to use
% maxTime = length in seconds of each run
% nBins = number of bins (eg 200)

function [numSCCC, numDiffs, edges] = ...
                      makeSCCCplot(savedSpikeTimes1, runIdx1, cellIdx1, ...
                      savedSpikeTimes2, runIdx2,cellIdx2, ...
                      maxTime, nBins, figNum)

if(length(runIdx1) ~= length(runIdx2))
    sprintf('runIdx1 = %d\nrunIdx2 = %d\nLengths do not match!', ...
            runIdx1, runIdx2)
    keyboard
end

nRuns = length(runIdx1);

% Extract the relevant spike information

for i=1:nRuns
    spikeTimesA{i} = savedSpikeTimes1{runIdx1(i)}{cellIdx1};
    spikeTimesB{i} = savedSpikeTimes2{runIdx2(i)}{cellIdx2};    
end


% Make Shuffle Corrected Cross Correlogram (SCCC)

tDiffs = [];
ctDiffs = [];

for i=1:nRuns
    nA = length(spikeTimesA{i});
    nB = length(spikeTimesB{i});
    
    timeDiffs = repmat(spikeTimesA{i}, 1, nB) ...
              - repmat(spikeTimesB{i}',nA,1);

    % Matlab is a bit too clever, if input is a row, find will return
    % a row, but if the matrix has more than two rows, it will return
    % a column, so we need to make sure the first case also returns a
    % column...
    
    if(size(timeDiffs,1) == 1)
      timeDiffs = timeDiffs';
    end      
          
    % To reduce size of timeDiffs, just keep spike pairs that are
    % within 250 of one another, this still keeps waaay too many pairs

    tDiffs = [tDiffs; timeDiffs(find(abs(timeDiffs) < 250e-3))];
            
    % Generate shuffle correction timediffs to remove bias
    % the idea is that by shifting one spike trace n periods
    % any short time correlations are broken

    offsets = 0.5:0.5:(maxTime-0.5);
    nOfs = length(offsets);       
    
    for ofs = offsets
    
        corrTimeDiffs = repmat(spikeTimesA{i}, 1, nB) ...
                      - repmat(spikeTimesB{i}',nA,1) + ofs;

        addCtDiffs = corrTimeDiffs(find(abs(corrTimeDiffs) < 250e-3));
        
        if(size(addCtDiffs,1) == 1)
            addCtDiffs = addCtDiffs';
        end
                  
        ctDiffs = [ctDiffs; addCtDiffs];
    
    end
end

% Generate the plot

% nBins = 200;
edges = linspace(-0.25,0.25,nBins);

numDiffs = histc(tDiffs, edges);   % spike diff historgram
numDiffsC = histc(ctDiffs, edges); % correction
% keyboard

[rn,cn] = size(numDiffs);
if(rn < cn)
  numDiffs = numDiffs';
end

[rn,cn] = size(numDiffsC);
if(rn < cn)
  numDiffsC = numDiffsC';
end


if(~isempty(numDiffs) & ~isempty(numDiffsC))
  numSCCC = numDiffs - numDiffsC/nOfs;
else
  disp('numDiffs and/or numDiffsC is empty')
  numSCCC = zeros(size(edges));
end

if(isempty(numDiffs))
  numDiffs = zeros(size(edges)); 
end

if(isempty(numDiffsC))
  numDiffsC = zeros(size(edges)); 
end




if(figNum > 0)
    figure(figNum), clf
    subplot(2,1,1)
    bar(edges, numDiffs, 'histc')
    title('Raw spike difference')
    subplot(2,1,2)
    bar(edges, numSCCC, 'histc')
end
