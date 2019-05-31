%
% For supplementary material figure S4A
%
% Cur inject -- freq figure
% /home/hjorth/genesis/fsCurInputInhomogeneNetwork
%
%
% runTenFScurInejctInhomogeneNetworkGJscan.m
% readTenFSGJscanInjectCur.m
% makeTenFS3dGJscanPlotcurInject.m
%
% or
%
% makeTenFSGJscanPlotCurInject

close all

if(~exist('filteredFirst50MS'))
  filteredFirst50MS = 1;
  disp('Filtering out the first 50 ms of the run')
  disp('There is an initial spike when current injection starts')
  
  for i=1:length(savedSpikeTimes)
    for j=1:length(savedSpikeTimes{i})
      k = find(savedSpikeTimes{i}{j} < 50e-3);
      savedSpikeTimes{i}{j}(k) = [];
    end
    maxTime(i) = maxTime(i) - 50e-3;
  end
end

disp('This code handles plots even if there are no spikes for some cells')
disp('makeTenFS3dGJscanPlot.m doesnt do that')


clear pHand, pHand = [];

clear saveHandle saveFileName

%%%%% First lets make 2D conductance vs spike freq plots

uNumGaps = unique(numGaps);

for i=1:length(savedSpikeTimes)
  for j=1:length(savedSpikeTimes{1})
    outFreq(i,j) = length(savedSpikeTimes{i}{j})/maxTime(i);      
  end
end



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

figure(1), clf

p = plot(1./[max(uGJres{2}) min(uGJres{2})], repmat(meanFSfreq{1},2,1), ...
         1./uGJres{2}, meanFSfreq{2}); hold on

errorbar(mean(1./[max(uGJres{2}) min(uGJres{2})]), ...
         meanFSfreq{1}, -stdFSfreq{1}, stdFSfreq{1}, '*k')
errorbar(1./uGJres{2}, meanFSfreq{2}, -stdFSfreq{2}, stdFSfreq{2}, '*k')

xlabel('Conductance (S)')
ylabel('Spike frequency')

legend(p, ['Num GJ : ' num2str(uNumGaps(1))], ...
          ['Num GJ : ' num2str(uNumGaps(2))])

saveHandle{1} = gcf;
saveFileName{1} = 'FIGS/TenFS/freqSpikes-STD-curinject.fig';
%saveas(gcf, 'FIGS/TenFS/freqSpikes-STD.fig', 'fig')
   
      
figure(2), clf

% p = plot(1./[uGJres{2}(2) uGJres{2}(end)], repmat(meanFSfreq{1},2,1), ...
%          1./uGJres{2}(2:end), meanFSfreq{2}(2:end)); hold on

p = plot([1e9./uGJres{2}(1:end) 0], [meanFSfreq{2}(1:end) meanFSfreq{1} ]);
     hold on
     
     
errorbar([1e9./uGJres{2}(1:end) 0], ...
         [meanFSfreq{2}(1:end) meanFSfreq{1} ], ...
         [-stdmFSfreq{2}(1:end) -stdmFSfreq{1}], ...
         [ stdmFSfreq{2}(1:end) stdmFSfreq{1}], '*k')

a = axis;
a(1) = 0;
a(2) = 1e9./uGJres{2}(1);
a(3) = 0;
axis(a)
     
xlabel('Conductance (nS)','fontsize',24)
ylabel('Spike frequency (Hz)', 'fontsize',24)
set(gca,'fontsize',24)

%legend(p, ['Num GJ : ' num2str(uNumGaps(1))], ...
%          ['Num GJ : ' num2str(uNumGaps(2))])

%saveas(gcf, 'FIGS/TenFS/freqSpikes-STDerr.fig', 'fig')
saveHandle{2} = gcf;
saveFileName{2} = 'FIGS/TenFS/freqSpikes-STDerr-curinject.fig';

%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3), clf

colCtr = 0;

lineStyle = {'-','--','-.',':'};

for uRand = unique(conMatRandSeed)
  ridx = find(uRand == conMatRandSeed);
  [foo gidx] = sort(gapResistance(ridx));
  idx = ridx(gidx);
  
  hold on
  
  %plot(1e9./gapResistance(idx),outFreq(idx,:),'-','linewidth',2,'color',col)
  
  for i = 1:size(outFreq,2)
    plot(1e9./gapResistance(idx),outFreq(idx,i),...
         'linewidth',2,'linestyle',lineStyle{mod(i-1,length(lineStyle))+1}, ...
         'color', [0 0 0])
    colCtr = colCtr + 1;
  end
end

xlabel('Conductance (nS)','fontsize',24)
ylabel('Average spike frequency (Hz)','fontsize',24)
set(gca,'fontsize',20)
box off

saveHandle{3} = gcf;
saveFileName{3} = 'FIGS/TenFS/TenFS-allFreq-curInject.fig';


for i=1:length(saveHandle)
  saveas(saveHandle{i},saveFileName{i},'fig')
  saveas(saveHandle{i},strrep(saveFileName{i},'.fig','.eps'),'psc2')
end
