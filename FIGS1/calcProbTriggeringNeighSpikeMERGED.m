% First run:
% readLARGEnetOnlyPrimWrappedNGJ.m
% calcProbTriggeringNeighSpike.m
% readLARGEnetOnlySecWrappedNGJ.m
% calcProbTriggeringNeighSpike.m
%
% Then run this file.
% calcProbTriggeringNeighSpikeMERGED.m

clear all, close all

prim = load('UTDATA/SAVED/LARGEFSGJAllUpstateOnlyPrimWrappedNGJscan/pTrig.mat');
sec = load('UTDATA/SAVED/LARGEFSGJAllUpstateOnlySecWrappedNGJscan/pTrig.mat');

e(2) = errorbar(sec.nGJ, sec.nTrig, -sec.nTrigErr, sec.nTrigErr, ...
                '-', 'linewidth',2,'color',[0.5 0.5 0.5]);
hold on   
            
e(1) = errorbar(prim.nGJ, prim.nTrig, -prim.nTrigErr, prim.nTrigErr, ...
                '-', 'linewidth',2,'color',[0 0 0]);

legend(e,'Proximal','Distal','location','best')
           
            
xlabel('Number of GJ per FS','fontsize',24)
ylabel('Spikes propagated','fontsize',24)
set(gca,'fontsize',20)
box off
%a = axis; a(1) = 0; a(2) = max(max(sec.nGJ),max(prim.nGJ))+0.3; axis(a);
a = axis; a(1) = 0; a(2) = min(max(sec.nGJ),max(prim.nGJ))+0.3; axis(a);

saveas(gcf,'FIGS/FSLARGE-probability-of-triggering-neigh-spike-MERGED.fig','fig')
saveas(gcf,'FIGS/FSLARGE-probability-of-triggering-neigh-spike-MERGED.eps','psc2')

