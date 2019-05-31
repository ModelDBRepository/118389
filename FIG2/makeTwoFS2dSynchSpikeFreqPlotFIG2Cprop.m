% To generate Figure 2C
%
% runTwoFS.m
% readTwoFS.m
% makeTwoFS2dSynchSpikeFreqPlotFIG2Cprop.m
%

close all

% Synchronous time window
%dT = 20e-3
dT = [20e-3 10e-3 5e-3]
nNeigh = 1

% dT = 10 % Test just to verify that all lines appear on one line, true


clear pHand, pHand = [];

clear saveHandle saveFileName


%%%%% First lets make 2D, conductance vs spike freq, plots

uNumGaps = unique(numGaps);

for i=1:length(savedSpikeTimes)
  for j=1:length(savedSpikeTimes{1})
    outFreq(i,j) = length(savedSpikeTimes{i}{j})/maxTime(i);      
  end
end

clear meanFSfreq stdFSfreq stdmFSfreq


for iGap = 1:length(uNumGaps)
  % Find all data-sets with the same number of gap junctions
  iMask = find(numGaps == uNumGaps(iGap));
  
  uGJres{iGap} = unique(gapResistance(iMask));

  for iRes = 1:length(uGJres{iGap})
    % Loop through all gap junction resistances
    iGJres = iMask(find(gapResistance(iMask) == uGJres{iGap}(iRes)));
    
    allFreq = outFreq(iGJres,:);
    meanFSfreq{iGap}(iRes) = mean(allFreq(:));
    stdFSfreq{iGap}(iRes) = std(allFreq(:));
    stdmFSfreq{iGap}(iRes) = std(allFreq(:))/sqrt(length(allFreq(:))-1);
  end
end

figure,clf,pHand=[pHand subplot(1,1,1)];

p = plot([1./uGJres{2}(1:end) 0], [meanFSfreq{2}(1:end) meanFSfreq{1} ]);
     hold on


errorbar([1./uGJres{2}(1:end) 0], ...
         [meanFSfreq{2}(1:end) meanFSfreq{1} ], ...
         [-stdmFSfreq{2}(1:end) -stdmFSfreq{1}], ...
         [ stdmFSfreq{2}(1:end) stdmFSfreq{1}], '*k')

a = axis;
a(1) = 0 - 1e-11;
a(2) = 1./uGJres{2}(1) + 1e-11;
a(3) = 0;
axis(a)

xlabel('Conductance (S)')
ylabel('Spike frequency')

saveHandle{1} = gcf;
saveFileName{1} = 'FIGS/TwoFS-freqSpikes-STDerr.fig';
      

%%%%% Lets make spike freq plots for spikes with neighbourspikes close by

clear freqSynchPairs

for idT = 1:length(dT)

  for iGap = 1:length(uNumGaps)
    % Find those with same # GJ
    iMask = find(numGaps == uNumGaps(iGap));
  
    uGJres{iGap} = unique(gapResistance(iMask));
  
    for iRes = 1:length(uGJres{iGap})
      % Loop through GJ resistances
      iGJres = iMask(find(gapResistance(iMask) == uGJres{iGap}(iRes)));
    
      nCells = numCells(iGJres(1));


      combCtr = 1;
    
      for k=1:length(iGJres)
        runIdx = iGJres(k);
        
        for i=1:nCells
          neighSpikes = [];
          
          % Check all combos but with itself, hence the setdiff
          for j=setdiff(1:nCells,i)
            neighSpikes = [neighSpikes; savedSpikeTimes{runIdx}{j}];
          end
          
          freqSynchPairs{iGap}{idT}(iRes,combCtr) = ...
           countSpikesWithNumNeighbourSpikes(savedSpikeTimes{runIdx}{i}, ...
                                             neighSpikes, dT(idT), nNeigh) ... 
                                             / maxTime(runIdx);
                                  

          combCtr = combCtr + 1;
        end
      end
    end
  end
end

% uNumGaps(1) should be 0, it is the reference simulation

clear meanFreqSync stdmFreqSynch

for idT = 1:length(dT)
  for iGap = 1:length(uNumGaps)

    meanFreqSynch{iGap}{idT} = mean(freqSynchPairs{iGap}{idT},2);
    stdmFreqSynch{iGap}{idT} = std(freqSynchPairs{iGap}{idT},0,2) ...
                             / sqrt(size(freqSynchPairs{iGap}{idT},2)-1);
  end
end
  
figure,clf,pHand=[pHand subplot(1,1,1)];


% Here we assume there is only two sets of GJ configurations, the ref
% run and one other run.

clear p

marker = {'--k','k-',':k'}; 

for idT = 1:length(dT)

  xVal = [1e9*1./uGJres{2}(1:end) 0];
  yVal = [meanFreqSynch{2}{idT}(1:end)' meanFreqSynch{1}{idT}] ...
          ./ [meanFSfreq{2}(1:end) meanFSfreq{1}];

  yUpErr = ([meanFreqSynch{2}{idT}(1:end)' meanFreqSynch{1}{idT}] ...
             + [stdmFreqSynch{2}{idT}(1:end)' stdmFreqSynch{1}{idT}]) ...
           ./ ([meanFSfreq{2}(1:end) meanFSfreq{1}] ...
                - [ stdmFSfreq{2}(1:end) stdmFSfreq{1}]) ...
           -yVal;

  yLowErr = ([meanFreqSynch{2}{idT}(1:end)' meanFreqSynch{1}{idT}] ...
             - [ stdmFreqSynch{2}{idT}(1:end)' stdmFreqSynch{1}{idT}]) ...
           ./ ([meanFSfreq{2}(1:end) meanFSfreq{1}] ...
                + [stdmFSfreq{2}(1:end) stdmFSfreq{1}]) ...
           -yVal;
            
  p(idT) = plot(xVal,yVal, marker{idT}), hold on            

  errorbar(xVal,yVal,yLowErr,yUpErr,'*k')


  pLeg{idT} = ['Spike pair within ' num2str(dT(idT)) 's'];
end
 
legend(p, pLeg, 'location', 'best')


a = axis;
a(1) = 0 - 1e-11;
a(2) = 1e9*(1./uGJres{2}(1) + 1e-11);
a(3) = 0;
axis(a)

xlabel('Conductance (nS)')
ylabel('Proportion of spikes')

saveHandle{end+1} = p(end);
saveFileName{end+1} = ...
    ['FIGS/TwoFS-synchSpikePairs-AllPairs-GJ-' ...
      num2str(uNumGaps(iGap)) '-prop.fig'];




% Save all figures

for i=1:length(saveHandle)
  saveas(saveHandle{i},saveFileName{i},'fig') 
end



