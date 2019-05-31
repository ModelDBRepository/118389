% spikeTimes = spike times matrix, one input train per column
% dJit = std deviation of gauss distribution used
%
% The purpose of this function is to preserve the correlation
% needed in the JHK FS cell model to get the correct number of
% spikes, rise time and other dynamics.
%

function spikeOut = gaussJitterInputKeepCorr(spikeTimes, dJit, maxTime)

% Tanken med koden är att efter jittringen ska tidigare synkrona
% spikar fortfarande vara synkrona. Det ordnas genom att alla
% sorteras, sedan skapas en jittringsvektor som ser till att
% detta är uppfyllt. Därefter adderas denna jittringsvektorn
% till de osorterade ursprungstiderna, det fina är att jittringen
% permuteras så att alla kommer på rätt plats.


spikeOut = spikeTimes;

[r,c] = size(spikeTimes);

% Ugly fix to handle that all x(:) of a row vector returns a row
% vector, where all other y(:) returns a column vector.
if(r == 1)
  spikeTimes = spikeTimes';
end

[st,si] = sort(spikeTimes(:));

tJit = zeros(size(st));

dt = dJit*randn(1);
tJit(1) = dt; 

for i=2:length(st)
  if(st(i) ~= st(i-1))
    dt = dJit*randn(1);
  end

  tJit(i) = dt;
    
end

spikeOut(si) = spikeTimes(si) + tJit;

% Only sort by column if we have more than 1 row, for a row vector the
% sorting will result in the first synapses getting the early spikes
% ALWAYS, and we do not want that!
if(r > 1)
  spikeOut = sort(mod(spikeOut, maxTime));
else
  spikeOut = mod(spikeOut, maxTime);
end
