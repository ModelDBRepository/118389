% Purpose of this file is to generate a plot showing the average number 
% of spike pairs that a neuron is involved in
%
% It also shows the result if the output spikes are shuffled
%
%
% Figure 6E:
% runTenFShigherFreqLessShuntingSaveGJcur.m (same as 6B and 6C)
% readHigherFreqLessShuntingDataSavedGJcur
% makeFIG6spikePairsOnePairCLEAN
%


close all
dT = 5e-3

clear pHand, pHand = [];
clear saveHandle saveFileName

nNeigh = 1

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

if(length(unique(gapResistance)) > 2)
  disp('Code only supports connected and unconnected case') 
  keyboard
end


for iGap = 1:length(uNumGaps)
  % Find all files with the same #GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uUpFreq{iGap} = unique(upFreq(iMask));

  for iFreq = 1:length(uUpFreq{iGap})
    % Loop through GJ resistances
    idx = iMask(find(upFreq(iMask) == uUpFreq{iGap}(iFreq)));
    
    allFreq = outFreq(idx,:);
    meanFSfreq{iGap}(iFreq) = mean(allFreq(:));
    stdFSfreq{iGap}(iFreq) = std(allFreq(:));
    stdmFSfreq{iGap}(iFreq) = std(allFreq(:))/sqrt(length(allFreq(:))-1);

  end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate spike pair count vs conductance
% 
% * For connected neighbours
% * For neighbours not directly coupled
%


clear freqSynchConPairs
    
    
for iGap = 1:length(uNumGaps)
  % Hitta all data som har rätt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uUpFreq{iGap} = unique(upFreq(iMask));
  
  for iFreq = 1:length(uUpFreq{iGap})
    % Gå igenom varje resistans som finns för aktuella antal GJ
    idx = iMask(find(upFreq(iMask) == uUpFreq{iGap}(iFreq)));
    
    nCells = numCells(idx(1));   
    
    combCtr = 1;
    
    for i=1:length(idx)
      runIdx = idx(i);
  
      for j=1:size(conMat{idx(i)},1)                   
          
        % Only use neighbouring cells spikes as neighbouring spikes
        neighCells = find(conMat{idx(i)}(j,:));
        
        neighSpikes = [];
          
        for k=neighCells
          neighSpikes = savedSpikeTimes{runIdx}{k};

        
          freqSynchConPairs{iGap}(iFreq,combCtr) = ...
            countSpikesWithNumNeighbourSpikes(savedSpikeTimes{runIdx}{j}, ...
                                              neighSpikes, dT, 1) ...
                                              / maxTime(runIdx);
                                    
          combCtr = combCtr + 1;
        end
            
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

clear freqSynchALLpairs freqSynchALLpairsShuffled
    
for iGap = 1:length(uNumGaps)
  % Hitta all data som har rätt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uUpFreq{iGap} = unique(upFreq(iMask));
  
  for iFreq = 1:length(uUpFreq{iGap})
    % Gå igenom varje resistans som finns för aktuella antal GJ
    idx = iMask(find(upFreq(iMask) == uUpFreq{iGap}(iFreq)));
    
    nCells = numCells(idx(1));   
    
    combCtr = 1;
    
    for i=1:length(idx)
      runIdx = idx(i);
  
      for j=1:size(conMat{idx(i)},1)                   
          
        % Use all neurons as neighbours
        neighCells = setdiff(1:size(conMat{idx(i)},1),j);
        
        for k=neighCells
          neighSpikes = savedSpikeTimes{runIdx}{k};

        
          freqSynchALLpairs{iGap}(iFreq,combCtr) = ...
            countSpikesWithNumNeighbourSpikes(savedSpikeTimes{runIdx}{j}, ...
                                              neighSpikes, dT, 1) ...
                                              / maxTime(runIdx);

          freqSynchALLpairsShuffled{iGap}(iFreq,combCtr) = ...
            countSpikesWithNumNeighbourSpikes(savedSpikeTimes{runIdx}{j}, ...
                                              mod(neighSpikes+5,...
                                                  maxTime(runIdx)), ...
                                              dT, 1) / maxTime(runIdx);
                                          
          combCtr = combCtr + 1;
        end
            
      end
    end
    
  end
end

clear meanFreqSynchALL stdmFreqSynchALL
clear meanFreqSynchALLshuffled stdmFreqSynchALLshuffled

for iGap = 1:length(uNumGaps)

  meanFreqSynchALL{iGap} = mean(freqSynchALLpairs{iGap},2);
  stdmFreqSynchALL{iGap} = std(freqSynchALLpairs{iGap},0,2) ...
                          / sqrt(size(freqSynchALLpairs{iGap},2)-1);
                      
  meanFreqSynchALLshuffled{iGap} = mean(freqSynchALLpairsShuffled{iGap},2);
  stdmFreqSynchALLshuffled{iGap} = std(freqSynchALLpairsShuffled{iGap},0,2) ...
                          / sqrt(size(freqSynchALLpairsShuffled{iGap},2)-1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear freqSynchNonConPairs
    
    
for iGap = 1:length(uNumGaps)
  % Hitta all data som har rÃ¤tt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uUpFreq{iGap} = unique(upFreq(iMask));

  
  for iFreq = 1:length(uUpFreq{iGap})
    % GÃ¥ igenom varje resistans som finns fÃ¶r aktuella antal GJ
    idx = iMask(find(upFreq(iMask) == uUpFreq{iGap}(iFreq)));
    

    combCtr = 1;
    
    for i=1:length(idx)
        
      runIdx = idx(i);
      
      for j=1:size(conMat{idx(i)},1)                   

        % Only use non-connected cellspikes as neighbouring spikes
        neighCells = find(conMat{idx(i)}(j,:) == 0);
        % Remove self connections, dont want to compare pairs with ourselves
        neighCells = setdiff(neighCells,j);
        
        % Correction, because there are 3 connected neighbours and 
        % 7 non-connected neighbours. So we just use 3 of the
        % non-connected neighbours instead of all.
        % Will plot both.
        
        neighSpikes = [];
        
        % Randomize the order of neighbours, then just use 3 of them
        neighCells = neighCells(randperm(length(neighCells)));
        neighCells(4:end) = []; % Remove last ones
        
        for k=neighCells
          neighSpikes = savedSpikeTimes{runIdx}{k};
        
          freqSynchNonConPairsCORRECTED{iGap}(iFreq,combCtr) = ...
            countSpikesWithNumNeighbourSpikes(savedSpikeTimes{runIdx}{j}, ...
                                              neighSpikes, dT, nNeigh) ...
                                             / maxTime(runIdx);
                                   
                                    
          combCtr = combCtr + 1;
        end       
        
      end
    end
    
  end
end

clear meanFreqSynchNCP stdmFreqSynchNCP

for iGap = 1:length(uNumGaps)


  meanFreqSynchNCPcorr{iGap} = mean(freqSynchNonConPairsCORRECTED{iGap},2);
  stdmFreqSynchNCPcorr{iGap} = std(freqSynchNonConPairsCORRECTED{iGap},0,2) ...
                     / sqrt(size(freqSynchNonConPairsCORRECTED{iGap},2)-1);
             
end

 
fSpik = meanFSfreq{2};
% P(minst en) = 1 - P(ingen granne spikar)
nSpikPair = fSpik .* (1 - exp(-fSpik*2*dT));
%nSpikPairNC = fSpik .* (1 - exp(-fSpik*2*dT));
fSpikNC = meanFSfreq{1};
nSpikPairNC = fSpikNC .* (1 - exp(-fSpikNC*2*dT));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Plotta

figure,clf,pHand=[pHand subplot(1,1,1)];


% Here we assume there is only two sets of GJ configurations, the ref
% run and one other run.
pA = plot(uUpFreq{2}, meanFreqSynchCP{2}, ...
         ':','linewidth',4,'color',[0.5 0.5 0.5]);
     hold on

    
errorbar(uUpFreq{2}, meanFreqSynchCP{2}, ...
         -stdmFreqSynchCP{2}, stdmFreqSynchCP{2}, ...
         '.','color',[0.5 0.5 0.5])
     
pALLgj = plot(uUpFreq{2}, meanFreqSynchALL{2}, 'k-','linewidth',2);
pALLnc = plot(uUpFreq{1}, meanFreqSynchALL{1}, 'k-.','linewidth',2);

errorbar(uUpFreq{2}, meanFreqSynchALL{2}, ...
         -stdmFreqSynchALL{2}, stdmFreqSynchALL{2}, '.k')
errorbar(uUpFreq{1}, meanFreqSynchALL{1}, ...
         -stdmFreqSynchALL{1}, stdmFreqSynchALL{1}, '.k')

     

     

pGJs = plot(uUpFreq{2}, meanFreqSynchALLshuffled{2}, '--k','linewidth',2);
%pNCs = plot(uUpFreq{1}, meanFreqSynchALLshuffled{1}, '-.k','linewidth',2);

errorbar(uUpFreq{2}, meanFreqSynchALLshuffled{2}, ...
         -stdmFreqSynchALLshuffled{2}, stdmFreqSynchALLshuffled{2}, '.k')
%errorbar(uUpFreq{1}, meanFreqSynchALLshuffled{1}, ...
%         -stdmFreqSynchALLshuffled{1}, stdmFreqSynchALLshuffled{1}, '.k')

    
legend([pALLnc pALLgj pGJs pA], ...
       'No gap junctions', ...
       'Gap junctions', ...
       'Gap junctions (shuffled)', ...
       'Direct gap junctions', ...
       'location','best')

box off   
   
xlabel('Input frequency (Hz)','fontsize',24)
ylabel('Spike pair occurances (s^{-1})','fontsize',24)
set(gca,'FontSize',20)

title('More input more synchrony','fontsize',24)

%saveHandle{end+1} = pA(1);
saveHandle{1} = pA(1);
%saveFileName{end+1} = ...
saveFileName{1} = ...
    ['FIGS/TenFS-onePair-synchSpikePairs-inFreqVar-summaryFIG6-dT-' num2str(dT) ...
     '-GJ-' num2str(uNumGaps(iGap)) '.fig'];         



% Save all figures

for i=1:length(saveHandle)
  saveas(saveHandle{i},saveFileName{i},'fig')
  saveas(saveHandle{i},strrep(saveFileName{i},'.fig','.eps'),'psc2')
end
  
  
