% This script uses the same data as that for Figure 7D
%
% runLARGEAllUpstateOnlyPrimWrappedNGJscan.m
% runLARGEAllUpstateOnlySecWrappedNGJscan.m
%
%
% To generate Figure S1B:
%
% readLARGEnetOnlyPrimWrappedNGJ.m
% plotLARGEFreqForNGJ.m
% 
% readLARGEnetOnlySecWrappedNGJ.m
% plotLARGEFreqForNGJ.m
%
% then run this file.
%

clear all, close all

prim = load('UTDATA/SAVED/LARGEFSGJAllUpstateOnlyPrimWrappedNGJscan/spikeFreqData.mat');
sec = load('UTDATA/SAVED/LARGEFSGJAllUpstateOnlySecWrappedNGJscan/spikeFreqData.mat');

if(prim.nCells ~= sec.nCells)
  disp('Number of cells do not match')
  keyboard
end

e(2) = errorbar(sec.avgNumGaps, sec.meanFiringFreq, ...
                -sec.stdEOMFiringFreq, sec.stdEOMFiringFreq, ...
                'k-', 'linewidth', 2,'color',[0.5 0.5 0.5]);
hold on
e(1) = errorbar(prim.avgNumGaps, prim.meanFiringFreq, ...
                -prim.stdEOMFiringFreq, prim.stdEOMFiringFreq, ...
                'k-', 'linewidth', 2,'color',[0 0 0]);

legend(e,'Proximal','Distal')            
            
xlabel('Number of GJ per FS','fontsize',24)
ylabel('Firing frequency (Hz)','fontsize',24)
set(gca,'fontsize',20)
box off

aX = 0.1;
maxY = ceil(max([prim.meanFiringFreq + prim.stdEOMFiringFreq, ...
                 sec.meanFiringFreq + sec.stdEOMFiringFreq]))

%axis([0-aX ceil(max(sec.avgNumGaps))+aX 0 maxY]);
axis([0-aX ceil(max(prim.avgNumGaps))+aX 0 maxY]);

plotName = sprintf('FIGS/LARGEFS-numCells-%d-firingFreq-MERGED.fig', prim.nCells);

saveas(gcf,plotName,'fig');
saveas(gcf,strrep(plotName,'fig','eps'),'psc2');


