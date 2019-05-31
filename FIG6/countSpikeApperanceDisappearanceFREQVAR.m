%
% This code counts the following cases:
%
% * Spike dissappearing
% * Spike appearing when there is a neighbouring spike
% * Spike appearing when there is no neighbouring spike
%
% Addition: This code now handles several different frequencies, doing
% separate analysis on each
%
% Matlab scripts to generate Figure 6D:
%
% runTenFShigherFreqLessShunting.m  (same as 6A)
% readHigherFreqLessShuntingData
% countSpikeApperanceDisappearanceFREQVAR.m
%

close all

dT = 5e-3; %10e-3;

% Loop through all random seeds

uRand = unique(randSeed);
uUpFreq = unique(upFreq);

for rIdx = 1:length(uRand)
  
  for uIdx = 1:length(uUpFreq)
    
    idxGJ = find(randSeed == uRand(rIdx) ...
                  & numGaps == 15 & upFreq == uUpFreq(uIdx));
    idxNC = find(randSeed == uRand(rIdx) ...
                  & numGaps == 0 & upFreq == uUpFreq(uIdx));
  
    if(length(idxGJ) ~= 1 | length(idxNC) ~= 1)
      continue
      disp(['Skipping randSeed = ' num2str(uRand(rIdx))])
    end
  
    % Loop through all cells
  
    for cIdx = 1:length(savedSpikeTimes{idxNC})
        
      spikeFreqGJ{uIdx}(rIdx,cIdx) = ...
          length(savedSpikeTimes{idxGJ}{cIdx}) / maxTime(idxGJ);
      spikeFreqNC{uIdx}(rIdx,cIdx) = ...
          length(savedSpikeTimes{idxNC}{cIdx}) / maxTime(idxNC);
      
      spikeFreqLoss{uIdx}(rIdx,cIdx) = ...
          spikeFreqNC{uIdx}(rIdx,cIdx) - spikeFreqGJ{uIdx}(rIdx,cIdx);
      
      tDiff = repmat(savedSpikeTimes{idxGJ}{cIdx}, ...
                    1, length(savedSpikeTimes{idxNC}{cIdx})) ...
                 - repmat(savedSpikeTimes{idxNC}{cIdx}', ...
                    length(savedSpikeTimes{idxGJ}{cIdx}),1);
              
              
      % Start by finding if any of the NC neuron spikes are missing in
      % the GJ connected case. These dissappeared due to shunting.
      removedIdx = find(sum(abs(tDiff) < dT) == 0);
      tRemoved{uIdx}{rIdx}{cIdx} = savedSpikeTimes{idxNC}{cIdx}(removedIdx);
      nRemoved{uIdx}(rIdx,cIdx) = length(removedIdx) / maxTime(rIdx);
     
      % Now we want to see what new spikes appeared. They exist in the
      % GJ case but not in the NC case.
      addedIdx = find(sum(abs(tDiff) < dT,2) == 0);
      tAdded{uIdx}{rIdx}{cIdx} = savedSpikeTimes{idxGJ}{cIdx}(addedIdx);
      nAdded{uIdx}(rIdx,cIdx) = length(addedIdx) / maxTime(rIdx);

      % Ok, so now we found the added spikes, the question is, were
      % they triggered by a coupled neighbour spiking or not?
    
      % First, find out what cells this neuron cIdx is connected to
      % conMat contains the connection matrix
      neighIdx = find(conMat{rIdx}(cIdx,:));
     
      allNeighSpikes = [];
     
      for nIdx = neighIdx
        allNeighSpikes = [allNeighSpikes; savedSpikeTimes{idxNC}{nIdx}];
      end
   
      
      if(length(addedIdx) > 0)
        tDiffNeigh = repmat(savedSpikeTimes{idxGJ}{cIdx}(addedIdx), ...
                            1, length(allNeighSpikes)) ...
                       - repmat(allNeighSpikes', ...
                            length(savedSpikeTimes{idxGJ}{cIdx}(addedIdx)),1);
      else
        tDiffNeigh = [];
      end
                        
      % For a spike to have been triggered by a neighbouring spike that
      % spike has to appear before it, ie 0 < T(GJ) - Tn(NC) < dT
      addedWithNeighIdx = find(sum(0 < tDiffNeigh & tDiffNeigh < dT,2));
      tAddedWithNeigh{uIdx}{rIdx}{cIdx} = ...
                   tAdded{uIdx}{rIdx}{cIdx}(addedWithNeighIdx);
      tAddedWithoutNeigh{uIdx}{rIdx}{cIdx} = ...
                   setdiff(tAdded{uIdx}{rIdx}{cIdx}, ....
                           tAddedWithNeigh{uIdx}{rIdx}{cIdx});
    
      nAddedWithNeigh{uIdx}(rIdx,cIdx) = ...
                     length(tAddedWithNeigh{uIdx}{rIdx}{cIdx}) ...
                           / maxTime(rIdx);
      nAddedWithoutNeigh{uIdx}(rIdx,cIdx) = ...
                     length(tAddedWithoutNeigh{uIdx}{rIdx}{cIdx}) ...
                           / maxTime(rIdx);
    %keyboard

    end

  end
  
end

if(nnz(diff(maxTime)))
  disp('All maxTime are not equal!')
  keyboard
end

for uIdx = 1:length(uUpFreq)
  meanAdded(uIdx) = mean(nAdded{uIdx}(:));
  stdeAdded(uIdx) = std(nAdded{uIdx}(:))/sqrt(length(nAdded{uIdx}(:))-1);

  meanAddedWithNeigh(uIdx) = mean(nAddedWithNeigh{uIdx}(:));
  stdeAddedWithNeigh(uIdx) = std(nAddedWithNeigh{uIdx}(:)) ...
                        /sqrt(length(nAddedWithNeigh{uIdx}(:))-1);

  meanAddedWithoutNeigh(uIdx) = mean(nAddedWithoutNeigh{uIdx}(:));
  stdeAddedWithoutNeigh(uIdx) = std(nAddedWithoutNeigh{uIdx}(:))...
                           /sqrt(length(nAddedWithoutNeigh{uIdx}(:))-1);

  meanRemoved(uIdx) = mean(nRemoved{uIdx}(:));
  stdeRemoved(uIdx) = std(nRemoved{uIdx}(:)) ...
                       /sqrt(length(nRemoved{uIdx}(:))-1);
                   
  meanSpikeFreqGJ(uIdx) = mean(spikeFreqGJ{uIdx}(:));
  stdeSpikeFreqGJ(uIdx) = std(spikeFreqGJ{uIdx}(:)) ...
                          / sqrt(length(spikeFreqGJ{uIdx}(:))-1);
  meanSpikeFreqNC(uIdx) = mean(spikeFreqNC{uIdx}(:));
  stdeSpikeFreqNC(uIdx) = std(spikeFreqNC{uIdx}(:)) ...
                          / sqrt(length(spikeFreqNC{uIdx}(:))-1);

  meanSpikeFreqLoss(uIdx) = mean(spikeFreqLoss{uIdx}(:));
  stdeSpikeFreqLoss(uIdx) = std(spikeFreqLoss{uIdx}(:)) ...
                          / sqrt(length(spikeFreqLoss{uIdx}(:))-1);
end

close all

figure

p = plot(uUpFreq, meanRemoved, 'k-', ...
         uUpFreq, meanAddedWithoutNeigh, 'k--', ...
         uUpFreq, meanAddedWithNeigh, 'k-.', ...
         uUpFreq, meanSpikeFreqLoss, 'k:', ...
         'linewidth',2)
hold on

errorbar(uUpFreq, meanSpikeFreqLoss, ...
         -stdeSpikeFreqLoss, stdeSpikeFreqLoss, 'k.')
errorbar(uUpFreq, meanRemoved, ...
         -stdeRemoved, stdeRemoved, 'k.')
errorbar(uUpFreq, meanAddedWithoutNeigh, ...
         -stdeAddedWithoutNeigh, stdeAddedWithoutNeigh, 'k.')
errorbar(uUpFreq, meanAddedWithNeigh, ...
         -stdeAddedWithNeigh, stdeAddedWithNeigh, 'k.')
     
legend(p, 'Shunted', ...
          'Spontaneous', ...
          'Spike triggered', ...         
          'Net reduction', ...    
          'location','best')
  
xlabel('Input frequncy (Hz)','fontsize',24)
ylabel('Frequency (Hz)','fontsize',24)
set(gca,'FontSize',24)

title('Changed spike classification')

a = axis; 
a(1) = 0; 
a(2) = max(uUpFreq) + 0.5; 
a(3) = 0; % a(4) = a(4) + 1
axis(a);

box off

saveas(p(1), 'FIGS/countSpikeApperanceDisappearance-freqVar.fig', 'fig')
saveas(p(1), 'FIGS/countSpikeApperanceDisappearance-freqVar.eps', 'psc2')


%(meanRemoved - meanAddedWithNeigh - meanAddedWithoutNeigh) ...
%  ./(meanSpikeFreqNC - meanSpikeFreqGJ)



figure

p = plot(uUpFreq, meanAddedWithNeigh, 'k-', ...
         uUpFreq, meanAddedWithoutNeigh, 'k--', ...
         uUpFreq, meanRemoved, 'r-', ...
         uUpFreq, meanSpikeFreqGJ, 'b-',...
         uUpFreq, meanSpikeFreqNC, 'b--', ...
         'linewidth',2)
hold on

errorbar(uUpFreq, meanAddedWithNeigh, ...
         -stdeAddedWithNeigh, stdeAddedWithNeigh, 'k')
errorbar(uUpFreq, meanAddedWithoutNeigh, ...
         -stdeAddedWithoutNeigh, stdeAddedWithoutNeigh, 'k')
errorbar(uUpFreq,meanRemoved, ...
         -stdeRemoved, stdeRemoved, 'r')
errorbar(uUpFreq, meanSpikeFreqGJ, -stdeSpikeFreqGJ, stdeSpikeFreqGJ, 'b')
errorbar(uUpFreq, meanSpikeFreqNC, -stdeSpikeFreqNC, stdeSpikeFreqNC, 'b')
     
     
legend(p, 'Spike triggered spike', ...
          'Spontaneous spike', ...
          'Shunted spike (removed)', ...
          'Spike freq GJ', ...
          'Spike freq NC', ...
          'location','best')
  
xlabel('Input frequncy (Hz)','fontsize',20)
ylabel('Frequency of occurance (Hz)','fontsize',20)
set(gca,'FontSize',20)

a = axis; a(1) = 0; a(2) = max(uUpFreq) + 0.5; a(3) = 0; axis(a);
box off

saveas(p(1), 'FIGS/countSpikeApperanceDisappearance-withSpikeFreq-freqVar.fig', 'fig')
saveas(p(1), 'FIGS/countSpikeApperanceDisappearance-withSpikeFreq-freqVar.eps', 'psc2')


(meanRemoved - meanAddedWithNeigh - meanAddedWithoutNeigh) ...
  ./(meanSpikeFreqNC - meanSpikeFreqGJ)
