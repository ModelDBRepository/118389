%
% This code calculates the number of spikes triggered in neighbouring
% connected neurons after a neuron spikes.
%

close all

clear selfSpikes spikeTrig cMat

dtSpike = 10e-3;

for fileCtr = 1:length(savedSpikeTimes)
  
  if(numGaps(fileCtr) == 0)
    % No gap junctions 
    for cellCtr = 1:length(savedSpikeTimes{fileCtr})
       selfSpikes{fileCtr}(cellCtr) = length(savedSpikeTimes{fileCtr}{cellCtr});
       spikeTrig{fileCtr}(cellCtr) = 0;
    end
    
    continue;
  end
   
  cMat{fileCtr} = zeros([1 1]*length(savedSpikeTimes{fileCtr}));
  
  % Reconstruct the connection matrix cMat  
  for gapCtr = 1:numGaps(fileCtr)
    srcIdx = textscan(gapSource{fileCtr}{gapCtr}{1},'/fs[%d]'); 
    destIdx = textscan(gapDest{fileCtr}{gapCtr}{1},'/fs[%d]'); 
    
    % +1 since matlab indexing starts from 1, not 0
    cMat{fileCtr}(srcIdx{1}+1,destIdx{1}+1) = ...
         cMat{fileCtr}(srcIdx{1}+1,destIdx{1}+1) + 1;
    
    %keyboard
  end
  
  
  % cMat{fileCtr} = min(cMat{fileCtr} + cMat{fileCtr}',1);
  cMat{fileCtr} = cMat{fileCtr} + cMat{fileCtr}';
  
  % For each neuron that spikes, check if a neighbouring neuron spike
  % is triggered within dtSpike
  
  for cellCtr = 1:length(savedSpikeTimes{fileCtr})
    % Find the connected neurons
    neighIdx = find(cMat{fileCtr}(cellCtr,:));
    
    selfSpikes{fileCtr}(cellCtr) = length(savedSpikeTimes{fileCtr}{cellCtr});
    spikeTrig{fileCtr}(cellCtr) = 0;
    
    for sIdx = 1:length(savedSpikeTimes{fileCtr}{cellCtr})
      sTime = savedSpikeTimes{fileCtr}{cellCtr}(sIdx);
    
      for i = 1:length(neighIdx)
        % Find all neighbouring neurons
        neighSpikes = savedSpikeTimes{fileCtr}{neighIdx(i)};

        % Is there any spikes in the neighbouring neuron just after?
        if(find(sTime < neighSpikes & neighSpikes <= sTime + dtSpike))
          spikeTrig{fileCtr}(cellCtr) =  spikeTrig{fileCtr}(cellCtr) + 1;
        end
       
      end
    end
  end
end


uNumGaps = unique(numGaps);

for iGap=1:length(uNumGaps)
  fIdx = find(numGaps == uNumGaps(iGap));
  
  allSpikeTrig = [];
  allSelfSpikes = [];
  for fileCtr = fIdx
    sIdx = find(selfSpikes{fileCtr});
    allSpikeTrig = [allSpikeTrig, spikeTrig{fileCtr}(sIdx)];
    allSelfSpikes = [allSelfSpikes, selfSpikes{fileCtr}(sIdx)];
  end

  nAvgTrig(iGap) = mean(allSpikeTrig./allSelfSpikes);
  stdAvgTrig(iGap) = std(allSpikeTrig./allSelfSpikes);
  stdemAvgTrig(iGap) = stdAvgTrig(iGap) / sqrt(length(allSpikeTrig)-1);
  
end
    
nGJPerCell = 2*uNumGaps./numCells(1);

errorbar(nGJPerCell,nAvgTrig, ...
         -stdemAvgTrig,stdemAvgTrig, ...
         'k-','linewidth',2)
     
xlabel('Number of GJ per FS','fontsize',24)
ylabel('Spikes propagated','fontsize',24)
set(gca,'fontsize',20)
box off
a = axis; a(1) = 0; ...
axis(a);

saveas(gcf,'FIGS/FSLARGE-probability-of-triggering-neigh-spike.fig','fig')
saveas(gcf,'FIGS/FSLARGE-probability-of-triggering-neigh-spike.eps','psc2')

nGJ = nGJPerCell;
nTrig = nAvgTrig;
nTrigErr = stdemAvgTrig;

curPath = pwd;
cd(filePath);
save pTrig.mat nGJ nTrig nTrigErr
cd(curPath);
