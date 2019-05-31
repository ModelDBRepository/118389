% The purpose of this script is to plot the voltage difference over
% the gap junction as a function of input frequency
%
% Run simulation with: runTenInhomoFSGJcorrVariationSaveGJcur.m
% Read data with: readTenInhomoFScorrVarWithGJcur.m
%

close all
clear voltDiffHist voltDiffHistRel

% In the analyse script we calculated the GJ current, so lets do the
% calculation backwards to get the voltage difference...

voltEdges = linspace(-100e-3,50e-3,1501);

for fIdx = 1:length(GJcur)
  if(~isempty(GJcur{fIdx}))
    meanAbsVoltDiff(fIdx,:) = ...
         mean(abs(GJcur{fIdx}))*gapResistance(fIdx); 
  else
    meanAbsVoltDiff(fIdx,1:max(numGaps)) = NaN;
  end
  voltDiffHist(fIdx,:) = histc(GJcur{fIdx}(:)*gapResistance(fIdx),voltEdges);
end

% Sum together for neurons with same input freq

uupFreq = unique(upFreq);


% Reverse order, to make plot legend look nicer, we want the maximal
% curve to be at the top of the legend for easy reading.

clear meanCurTrace stdeCurTrace voltDiffHistRel

for uCtr = 1:length(uupFreq)

  uIdx = find(upFreq == uupFreq(uCtr));
  
  % Remove unconnected runs. ie where gap resistance is infinite
  uIdx(find(isinf(gapResistance(uIdx)))) = [];
    
  if(nnz(diff(gapResistance(uIdx))))
     disp('All gap junctions does not have same resistance, not supported!')
     keyboard
  end

  % Add all curTraces together
  tmp = meanAbsVoltDiff(uIdx,:);
  meanAbsVolt(uCtr) = mean(tmp(:));
  stdeAbsVolt(uCtr) = std(tmp(:)) / ...
                        sqrt(length(uIdx)-1);
  stdAbsVolt(uCtr) = std(tmp(:));
  
  voltDiffHistRel(uCtr,:) = sum(voltDiffHist(uIdx,:))...
                         / sum(sum(voltDiffHist(uIdx,:)));
                     
  tmp = GJvoltCov(uIdx,:);                   
  meanGJvoltCov(uCtr) = mean(tmp(:));
end

figure

p = plot(uupFreq,meanAbsVolt*1e3,'k','linewidth',2); hold on
errorbar(uupFreq,meanAbsVolt*1e3,-stdeAbsVolt*1e3,stdeAbsVolt*1e3,'*k')

a = axis;
a(1) = min(0,a(1));
a(3) = min(0,a(3));
axis(a);


xlabel('Input frequency (Hz)','fontsize',20)
ylabel('Voltage difference amplitude (mV)','fontsize',20)
set(gca,'FontSize',20)
%title('Current through gap junctions')

box off

saveas(p(1), 'FIGS/AbsVoltDiff-upFreq-plot.fig', 'fig')
saveas(p(1), 'FIGS/AbsVoltDiff-upFreq-plot.eps', 'psc2')


figure
%bar(voltEdges',voltDiffHistRel','histc'), hold on
ph = plot(voltEdges'*1e3,voltDiffHistRel','linewidth',2)
xlabel('Voltage difference (mV)','fontsize',20)
ylabel('Fraction of time','fontsize',20)
title('Gap junction voltage distribution','fontsize',24)

for i = 1:length(uupFreq)
  pLeg{i} = sprintf('Input %.1fHz',uupFreq(i));
end
legend(ph,pLeg,'location','NorthWest');

a = axis;
a(1) = -20; a(2) = 20; axis(a);
box off

set(gca,'FontSize',20)


saveas(ph(1), 'FIGS/VoltDiffHist-upFreq-plot.fig', 'fig')
saveas(ph(1), 'FIGS/VoltDiffHist-upFreq-plot.eps', 'psc2')


figure
plot(uupFreq, meanGJvoltCov,'*-k')
title('Covariance between voltages on either side of GJ')
a = axis; a(1) = 0; a(3) = 0; axis(a);

figure
plot(uupFreq, stdAbsVolt,'*-k')
title('Standard deviation of voltage difference')
a = axis; a(1) = 0; a(3) = 0; axis(a);

