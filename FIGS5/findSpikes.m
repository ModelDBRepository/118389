% [spikeTimes] = findSpikes(data, time)
% returns cell-array with spiketimes for different runs
% data = matrix, size is runLen rows and runNum cols

function [spikeTimes] = findSpikes(data, time)

[runLen runs] = size(data);

   
thresh = -0.035; % Spike filter threshold
events = (data > thresh).*data + (data <= thresh)*thresh;
                        
% A spike is a datapoint D above threshhold where the datapoints to
% the left and right are lower than D.    
            
% events(i-1) < events(i)
chkLeft = events(2:end,:) > events(1:end-1,:);
left  = [zeros(1, runs); chkLeft];
clear chkLeft


% events(i) > events(i+1)
chkRight = events(1:end-1,:) > events(2:end,:);
right = [chkRight; zeros(1, runs)]; 
clear chkRight

spikes = left & right;
clear left right

            
% The above definition misses spikes where two consequtive points
% above threshold are identical, lets find them too...
newspikes = [(events(1:end-1,:) == events(2:end,:)) ...
             & (events(1:end-1,:) > thresh); zeros(1, runs)];

spikes = spikes + newspikes;
clear newspikes

if(max(spikes) > 1)
    error('Matlab:OUCH!', 'Warning binary spikes matrix corrupt!')
end

for runIdx=1:runs
    spikeIdx = find(spikes(:, runIdx));    
    spikeTimes{runIdx} = time(spikeIdx);
end
