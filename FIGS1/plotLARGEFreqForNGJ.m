%
% runLARGEAllUpstateOnlyPrimWrappedNGJscan.m
% readLARGEnetOnlyPrimWrappedNGJ.m
% plotLARGEFreqForNGJ.m
%
% This code checks how the firing frequency varies with increased
% number of gap junctions in the network.
%

firingFreqAll = NaN*ones(length(savedSpikeTimes),length(savedSpikeTimes{1}));

for i=1:length(savedSpikeTimes)
  for j=1:length(savedSpikeTimes{i})
     firingFreqAll(i,j) = length(savedSpikeTimes{i}{j}) / maxTime(i);
  end
end

uNumGaps = unique(numGaps);

for i=1:length(uNumGaps)
  idx = find(uNumGaps(i) == numGaps);
  tmp = firingFreqAll(idx,:);
  meanFiringFreq(i) = mean(tmp(:));
  stdFiringFreq(i) = std(tmp(:));
  stdEOMFiringFreq(i) = stdFiringFreq(i) / sqrt(length(tmp(:)) - 1);
end

if(max(numCells) ~= min(numCells))
  disp('Not all simulations have same number of cells')
  keyboard
end
nCells = numCells(1);


% Factor 2 from fact that each connected GJ is seen by two FS
avgNumGaps = 2*uNumGaps./numCells(1);

errorbar(avgNumGaps, meanFiringFreq, -stdEOMFiringFreq, stdEOMFiringFreq, ...
         'k-', 'linewidth', 2);
     
xlabel('Number of GJ per FS','fontsize',24)
ylabel('Firing frequency (Hz)','fontsize',24)
set(gca,'fontsize',20)
box off

aX = 0.1;
axis([0-aX ceil(max(avgNumGaps))+aX 0 ceil(max(meanFiringFreq + stdEOMFiringFreq))]);

plotName = sprintf('FIGS/LARGEFS-numCells-%d-firingFreq.fig', numCells(1));

saveas(gcf,plotName,'fig');
saveas(gcf,strrep(plotName,'fig','eps'),'psc2');


curPath = pwd;
cd(filePath);
save spikeFreqData.mat avgNumGaps meanFiringFreq stdEOMFiringFreq nCells

cd(curPath);
