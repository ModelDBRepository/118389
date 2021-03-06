%
% To generate the supplementary figures S5:
%
% S5A
% runTenFSsensitivity.m
% readTenFSsensitivity
% makeShuntingSensitivityFigure.m
% 
%
% S5B
% runTenFSsensitivity.m     (same as in S5A)
% readTenFSsensitivity.m
% makeCorrPairFigure.m
%
% 
%
% This figure shows spike frequency on x-axis and frequency of spike
% pairs on the y-axis.
%

clear all, close all

fv = load('/home/hjorth/genesis/fsInhomogeneNetwork/FIG65-extracted.mat');

cv = load('TenFS-BlueGene.mat');


% fv generated by extractOutputFreqAndSpikePairsFromFIG6E.m
% see that file to see how the varibles in the mat-files were generated

interPol = 1;

if(~interPol)

  pA = plot(fv.meanFSfreq{2}, fv.meanFreqSynchCP{2}, ...
           ':','linewidth',4,'color',[0.5 0.5 0.5]);
       hold on
else
  dotRange = linspace(min(fv.meanFSfreq{2}),max(fv.meanFSfreq{2}),100);
  intY = interp1(fv.meanFSfreq{2},  fv.meanFreqSynchCP{2}, dotRange, 'pchip');

  pA = plot(dotRange, intY, ':','linewidth',4,'color',[0.5 0.5 0.5]);
  hold on
end
    
%errorbar(fv.meanFSfreq{2}, fv.meanFreqSynchCP{2}, ...
%         -fv.stdmFreqSynchCP{2}, fv.stdmFreqSynchCP{2}, ...
%         '.','color',[0.5 0.5 0.5])
     
%pALLgj = plot(fv.meanFSfreq{2}, fv.meanFreqSynchALL{2}, 'k-','linewidth',2);

if(~interPol)
  pALLnc = plot(fv.meanFSfreq{1}, fv.meanFreqSynchALL{1}, 'k-.','linewidth',2);
else
   dotRange = linspace(min(fv.meanFSfreq{1}),max(fv.meanFSfreq{1}),100);
   intY = interp1(fv.meanFSfreq{1},  fv.meanFreqSynchALL{1}, dotRange, 'pchip');
   pALLnc = plot(dotRange, intY, 'k-.','linewidth',2); 
   hold on
end
  
%errorbar(fv.meanFSfreq{2}, fv.meanFreqSynchALL{2}, ...
%         -fv.stdmFreqSynchALL{2}, fv.stdmFreqSynchALL{2}, '.k')
%errorbar(fv.meanFSfreq{1}, fv.meanFreqSynchALL{1}, ...
%         -fv.stdmFreqSynchALL{1}, fv.stdmFreqSynchALL{1}, '.k')

%pGJs = plot(fv.meanFSfreq{2}, fv.meanFreqSynchALLshuffled{2}, '--k','linewidth',2);

%errorbar(fv.meanFSfreq{2}, fv.meanFreqSynchALLshuffled{2}, ...
%         -fv.stdmFreqSynchALLshuffled{2}, fv.stdmFreqSynchALLshuffled{2}, '.k')

%%% Now add the data for channel parameters varied     
    
m1 = plot(cv.meanFreqGJPAR, cv.freqPairsGJPAR, '.k', 'markersize',28);
m2 = plot(cv.meanFreqRefPAR, cv.freqPairsRefPAR, 'ok', ...
    'markersize',8, 'linewidth',2);
  
textLabel = 1;
labelPoints = [] % [3 12 18 1]; % []; % Set to [] to remove labeling.
labelOfsX = [-0.1 -0.09 -0.05 -0.15];
labelOfsY = [-0.08 -0.08 -0.08 0.08];




for i = 1:length(cv.freqPairsGJPAR)
  if(ismember(i,labelPoints))
    labelIdx = find(ismember(labelPoints,i));
    if(textLabel)
      text(cv.meanFreqGJPAR(i)+labelOfsX(labelIdx), ...
          cv.freqPairsGJPAR(i)+labelOfsY(labelIdx), ...
          num2str(labelIdx),'fontsize',14)
    end
    plot(cv.meanFreqGJPAR(i), cv.freqPairsGJPAR(i),'.k','markersize',28)
    disp([num2str(labelIdx) ' - ' cv.pLeg{labelPoints(labelIdx)}])
  end
end
    
%legend([pALLnc pALLgj pGJs pA m1(1) m2(1)], ...
%       'No gap junctions', ...
%       'Gap junctions', ...
%       'Gap junctions (shuffled)', ...
%       'Direct gap junctions', ...
%       'Mod channel (GJ)', ...
%       'Mod channel (No GJ)', ...
%       'location','best')

legend([pA pALLnc m1(1) m2(1)], ...
       'Reference (GJ)', ...        % For this plot I label Direct GJ as just GJ
       'Reference (No GJ)', ...
       'Mod channel (GJ)', ...
       'Mod channel (No GJ)', ...
       'location','northwest')
   
   
box off   
   
xlabel('Firing frequency (Hz)','fontsize',24)
ylabel('Spike pair occurances (s^{-1})','fontsize',24)
set(gca,'FontSize',20)

saveas(gcf,'FIGS/TenFS-sense-spikePairs.fig','fig')
saveas(gcf,'FIGS/TenFS-sense-spikePairs.eps','psc2')
