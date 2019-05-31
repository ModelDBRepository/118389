% Figure 3B and 3C
%
% Matlab scripts:
%
% runTenInhomoFSGJscanAllUpstate
%
% readTenFSGJscanAllUpstate
% makeFIG3spikePairs
%
% Purpose of this file is to generate a plot showing the average number 
% of spike pairs that a neuron is involved in

close all
dT = 10e-3

clear pHand, pHand = [];
clear saveHandle saveFileName

nNeigh = 1

% readTenFSGJscanAllUpstate

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate conductance vs average firing frequency plot
%

uNumGaps = unique(numGaps);

for i=1:length(savedSpikeTimes)
  for j=1:length(savedSpikeTimes{1})
    outFreq(i,j) = length(savedSpikeTimes{i}{j})/maxTime(i);      
  end
end

clear meanFSfreq stdFSfreq stdmFSfreq


for iGap = 1:length(uNumGaps)
  % Hitta all data som har rätt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uGJres{iGap} = unique(gapResistance(iMask));

  for iRes = 1:length(uGJres{iGap})
    % Gå igenom varje resistans som finns för aktuella antal GJ
    iGJres = iMask(find(gapResistance(iMask) == uGJres{iGap}(iRes)));
    
    allFreq = outFreq(iGJres,:);
    meanFSfreq{iGap}(iRes) = mean(allFreq(:));
    stdFSfreq{iGap}(iRes) = std(allFreq(:));
    stdmFSfreq{iGap}(iRes) = std(allFreq(:))/sqrt(length(allFreq(:))-1);
  end
end


figure,clf,pHand=[pHand subplot(1,1,1)];

p = plot([1e9./uGJres{2}(1:end) 0], [meanFSfreq{2}(1:end) meanFSfreq{1}],'k-','linewidth',2);
     hold on


errorbar([1e9./uGJres{2}(1:end) 0], ...
         [meanFSfreq{2}(1:end) meanFSfreq{1} ], ...
         [-stdmFSfreq{2}(1:end) -stdmFSfreq{1}], ...
         [ stdmFSfreq{2}(1:end) stdmFSfreq{1}], '.k')

box off     
a = axis;
a(1) = 0 - 1e-2;
a(2) = 1e9./uGJres{2}(1) + 1e-2;
a(3) = 0;
axis(a)

set(gca,'FontSize',20)
xlabel('Conductance (nS)','FontSize',24)
ylabel('Spike frequency (Hz)','FontSize',24)

saveHandle{1} = gcf;
saveFileName{1} = 'FIGS/TenFS-freqSpikes-STDerrmean.fig';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate spike pair count vs conductance
% 
% * For connected neighbours
% * For neighbours not directly coupled
%


clear freqSynchConPairs
    
    
for iGap = 1:length(uNumGaps)
  % Hitta all data som har r�tt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uGJres{iGap} = unique(gapResistance(iMask));

  
  for iRes = 1:length(uGJres{iGap})
    % G� igenom varje resistans som finns f�r aktuella antal GJ
    iGJres = iMask(find(gapResistance(iMask) == uGJres{iGap}(iRes)));
    
    nCells = numCells(iGJres(1));   
    
    combCtr = 1;
    
    for i=1:length(iGJres)
      runIdx = iGJres(i);
  
      for j=1:size(conMat{iGJres(i)},1)                   
          
        % Only use neighbouring cells spikes as neighbouring spikes
        neighCells = find(conMat{iGJres(i)}(j,:));
        
        neighSpikes = [];
          
        for k=neighCells
          neighSpikes = [neighSpikes; savedSpikeTimes{runIdx}{k}];
        end

        
        freqSynchConPairs{iGap}(iRes,combCtr) = ...
          countSpikesWithNumNeighbourSpikes(savedSpikeTimes{runIdx}{j}, ...
                                        neighSpikes, dT, 1) ...
                                        / maxTime(runIdx);
                                    
        combCtr = combCtr + 1;
            
      end
    end
    
  end
end

clear meanFreqSynchCP stdmFreqSynchCP

for iGap = 1:length(uNumGaps)

  meanFreqSynchCP{iGap} = mean(freqSynchConPairs{iGap},2);
  stdmFreqSynchCP{iGap} = std(freqSynchConPairs{iGap},0,2) ...
                     / sqrt(size(freqSynchConPairs{iGap},2)-1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear freqSynchNonConPairs
    
    
for iGap = 1:length(uNumGaps)
  % Hitta all data som har rätt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uGJres{iGap} = unique(gapResistance(iMask));

  
  for iRes = 1:length(uGJres{iGap})
    % Gå igenom varje resistans som finns för aktuella antal GJ
    iGJres = iMask(find(gapResistance(iMask) == uGJres{iGap}(iRes)));
    

    combCtr = 1;
    
    for i=1:length(iGJres)
        
      runIdx = iGJres(i);
      
      for j=1:size(conMat{iGJres(i)},1)                   

        % Only use non-connected cellspikes as neighbouring spikes
        neighCells = find(conMat{iGJres(i)}(j,:) == 0);
        % Remove self connections, dont want to compare pairs with ourselves
        neighCells = setdiff(neighCells,j);
        
        neighSpikes = [];
 
        for k=neighCells
          neighSpikes = [neighSpikes; savedSpikeTimes{runIdx}{k}];
        end
 
        freqSynchNonConPairs{iGap}(iRes,combCtr) = ...
          countSpikesWithNumNeighbourSpikes(savedSpikeTimes{runIdx}{j}, ...
                                           neighSpikes, dT, nNeigh) ...
                                           / maxTime(runIdx);

        % Correction, because there are 3 connected neighbours and 
        % 7 non-connected neighbours. So we just use 3 of the
        % non-connected neighbours instead of all.
        % Will plot both.
        
        neighSpikes = [];
        
        % Randomize the order of neighbours, then just use 3 of them
        neighCells = neighCells(randperm(length(neighCells)));
        neighCells(4:end) = []; % Remove last ones
        
        for k=neighCells
          neighSpikes = [neighSpikes; savedSpikeTimes{runIdx}{k}];
        end       
        
        freqSynchNonConPairsCORRECTED{iGap}(iRes,combCtr) = ...
          countSpikesWithNumNeighbourSpikes(savedSpikeTimes{runIdx}{j}, ...
                                            neighSpikes, dT, nNeigh) ...
                                           / maxTime(runIdx);
                                   
                                    
        combCtr = combCtr + 1;
      end
    end
    
  end
end

clear meanFreqSynchNCP stdmFreqSynchNCP

for iGap = 1:length(uNumGaps)

  meanFreqSynchNCP{iGap} = mean(freqSynchNonConPairs{iGap},2);
  stdmFreqSynchNCP{iGap} = std(freqSynchNonConPairs{iGap},0,2) ...
                     / sqrt(size(freqSynchNonConPairs{iGap},2)-1);

  meanFreqSynchNCPcorr{iGap} = mean(freqSynchNonConPairsCORRECTED{iGap},2);
  stdmFreqSynchNCPcorr{iGap} = std(freqSynchNonConPairsCORRECTED{iGap},0,2) ...
                     / sqrt(size(freqSynchNonConPairsCORRECTED{iGap},2)-1);
             
end

 
fSpik = [meanFSfreq{2}(1:end) meanFSfreq{1}];
% P(minst en) = 1 - P(ingen granne spikar)
nSpikPair = fSpik .* (1 - exp(-fSpik*3*2*dT));
nSpikPairNC = fSpik .* (1 - exp(-fSpik*6*2*dT));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Plotta

figure,clf,pHand=[pHand subplot(1,1,1)];


% Here we assume there is only two sets of GJ configurations, the ref
% run and one other run.
pA = plot([1e9./uGJres{2}(1:end) 0], [meanFreqSynchCP{2}(1:end); meanFreqSynchCP{1}],'r-','linewidth',2);
     hold on

plot(0, meanFreqSynchCP{1},'.k','markersize',24)
    
errorbar([1e9./uGJres{2}(1:end) 0], ...
         [meanFreqSynchCP{2}(1:end); meanFreqSynchCP{1} ], ...
         [-stdmFreqSynchCP{2}(1:end); -stdmFreqSynchCP{1}], ...
         [ stdmFreqSynchCP{2}(1:end); stdmFreqSynchCP{1}], '.k')    

% Divide by 2 to compensate for fact that there are 6 indirectly
% neighbours, and only 3 directly coupled neighbours
% WRONG!! Don't do that... since there might be more than one spike
% close to another spike that will give an underestimation, use the
% corr-version calculated above instead

%pB = plot([1e9./uGJres{2}(1:end) 0], ...
%          [meanFreqSynchNCP{2}(1:end); meanFreqSynchNCP{1}]/2,'k-','linewidth',2);
pB = plot([1e9./uGJres{2}(1:end) 0], ...
          [meanFreqSynchNCPcorr{2}(1:end); meanFreqSynchNCPcorr{1}], ...
          'k-','linewidth',2);

%plot(0,meanFreqSynchNCP{1}/2,'.k','markersize',24)     
plot(0,meanFreqSynchNCPcorr{1},'.k','markersize',24)     
     

%errorbar([1e9./uGJres{2}(1:end) 0], ...
%         [meanFreqSynchNCP{2}(1:end); meanFreqSynchNCP{1}]/2, ...
%         [-stdmFreqSynchNCP{2}(1:end); -stdmFreqSynchNCP{1}]/2, ...
%         [ stdmFreqSynchNCP{2}(1:end); stdmFreqSynchNCP{1}]/2, '.k')    

errorbar([1e9./uGJres{2}(1:end) 0], ...
         [meanFreqSynchNCPcorr{2}(1:end); meanFreqSynchNCPcorr{1}], ...
         [-stdmFreqSynchNCPcorr{2}(1:end); -stdmFreqSynchNCPcorr{1}], ...
         [ stdmFreqSynchNCPcorr{2}(1:end); stdmFreqSynchNCPcorr{1}], '.k')    
     

pC = plot([1e9*1./uGJres{2}(1:end) 0], nSpikPair, '--k','linewidth',2)
%pD = plot([1e9*1./uGJres{2}(1:end) 0], nSpikPairNC, ':k')

legend([pA pB pC], ...
       'Directly connected', ...
       'Indirectly connected', ...
       'Random poisson', ...
       'location','best')

box off   
   
a = axis;
a(1) = 0 - 1e-2;
a(2) = 1e9./uGJres{2}(1) + 1e-2;
a(3) = 0;
axis(a)

xlabel('Conductance (nS)','fontsize',24)
ylabel('Spike pair frequency (Hz)','fontsize',24)
set(gca,'FontSize',20)

saveHandle{end+1} = pA(1);
saveFileName{end+1} = ...
    ['FIGS/TenFS-synchSpikePairs-summaryFIG3-dT-' num2str(dT) ...
     '-GJ-' num2str(uNumGaps(iGap)) '.fig'];         



% Save all figures

for i=1:length(saveHandle)
  saveas(saveHandle{i},saveFileName{i},'fig')
end
  
  
