% To generate Figure 7C
%
% runLARGEFSwithShiftingCorr.m
% read125FSshiftCorrTHROWAWAYDATA.m
% makeShiftCorrPlot125FS.m
% 
%
% This code plots a histogram showing average spike frequency over the
% period time, with and without gap junctions.
%
% Read the data with: read125FSshiftCorrTHROWAWAYDATA.m
%
% It only uses the inner most 27 neurons for the histogram, 
% those are the only ones receiving a correlation increase.
% 

close all

% First, identify the indexes of the center 27 neurons.

[Xc,Yc,Zc] = meshgrid(-2:2,-2:2,-2:2);
cIdx = find( -1 <= Xc & Xc <= 1 & ...
             -1 <= Yc & Yc <= 1 & ...
             -1 <= Zc & Zc <= 1);


for i=1:length(periodLen)
  for j=1:max(length(periodLen{1}),length(periodLen{i}))
    if(periodLen{i}(j) ~= periodLen{1}(j) ...
        | corrFlag{i}(j) ~= corrFlag{1}(j))
      disp('The directory contains more than one set of inputs, aborting')
      keyboard
    end
  end
end

uNumGaps = unique(numGaps);

clear allSpikes
clear numPeriods

for iGaps = 1:length(uNumGaps)
  allSpikes{iGaps} = [];
  numPeriods{iGaps} = 0;

  for idx = find(numGaps == uNumGaps(iGaps));
    for i = cIdx' % Only use center neurons.     1:numCells(idx)
      allSpikes{iGaps} = [allSpikes{iGaps}; savedSpikeTimes{idx}{i}];
      numPeriods{iGaps} = numPeriods{iGaps} + maxTime(idx)/sum(periodLen{idx});
    end
  end
end

%edges = linspace(0,1,51);
%edges = linspace(0,0.5,51);
edges = linspace(0,0.5,101);

binSize = edges(2) - edges(1);

plotOffset = 0.320

for iGaps = 1:length(uNumGaps)
 % Just add +0.32 to center peak, so it starts at 0.300
 [n,bin] = histc(mod(plotOffset + allSpikes{iGaps},0.5),edges);
 %[n,bin] = histc(mod(allSpikes{iGaps},0.5),edges);
 nSpik{iGaps} = n/(numPeriods{iGaps}*binSize);
 spikMax(iGaps) = max(nSpik{iGaps});
end

clear ax

figure

aMaxY = 0;

for iGaps = 1:length(uNumGaps)
  ax(iGaps) = subplot(length(uNumGaps),1,iGaps);
  bar(edges*1e3,nSpik{iGaps},'histc')
  title(sprintf('#GJ = %d', uNumGaps(iGaps)), 'fontsize',20)
  xlabel('Time (ms)', 'fontsize',20)
  ylabel('Frequency (Hz)', 'fontsize',20)
  set(gca,'fontsize',20)

  a = axis; a(1) = edges(1)*1e3; a(2) = edges(end)*1e3; axis(a);

  aMaxY = max(aMaxY,a(4));
end



for iGaps = 1:length(ax)
  subplot(ax(iGaps))
  a = axis;

  lineId = line(mod([0.48 0.5]+plotOffset,0.5)*1e3, ...
                 1/10*(aMaxY + max(spikMax))/2*[1 1], ...
                'color',[1 1 1],'linewidth',4);

  a(4) = aMaxY;
  axis(a);
end

%linkaxes(ax,'y')
linkaxes(ax,'x')

box off
saveas(ax(1), 'FIGS/LARGEFS-CorrFlag-varyingInput-GJeffect.fig','fig')
saveas(ax(1), 'FIGS/LARGEFS-CorrFlag-varyingInput-GJeffect.eps','psc2')





%%%%%%%%%%%%%%%%%%%%5
% No ref in this figure


clear ax

figure

aMaxY = 0;

for iGaps = 2
  p = bar(edges*1e3,nSpik{iGaps},'histc')
  shading flat

  hold on
  p2 = stairs(edges(1:end)*1e3,nSpik{1}(1:end),'k','linewidth',1);
  %title(sprintf('#GJ = %d', uNumGaps(iGaps)), 'fontsize',20)
  %xlabel('Time (ms)', 'fontsize',20)
  ylabel('Average frequency (Hz)', 'fontsize',20)
  set(gca,'fontsize',20)
  set(gca,'xtick',[])
  text(270-50,0.8,'20 ms correlation','fontsize',20)

  a = axis; a(1) = edges(1)*1e3; a(2) = edges(end)*1e3; axis(a);

  aMaxY = max(aMaxY,a(4));
end

set(p(1), 'facecolor',0.5*[1 1 1])



  a = axis;

  lineId = line(mod([0.48 0.5]+plotOffset,0.5)*1e3, ...
                 1/5*(aMaxY + max(spikMax))/2*[1 1], ...
                'color',[0 0 0],'linewidth',8);

  a(4) = 7 %aMaxY;
  axis(a);
box off


saveas(p(1), 'FIGS/LARGEFS-CorrFlag-varyingInput-GJeffect-lineRef.fig','fig')
saveas(p(1), 'FIGS/LARGEFS-CorrFlag-varyingInput-GJeffect-lineRef.eps','psc2')
