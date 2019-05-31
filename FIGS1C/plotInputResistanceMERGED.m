% This code calculates the input resistance for a FS neuron in a
% population, where each neuron has nAvgGJ number of gap junctions.
%
%
% Run the following script to generate the data:
%
% calcInputResistance.m
% calcInputResistanceSecDend.m
% 
% First parse and plot the figures:
% 
% plotInputResistance.m
% plotInputResistanceSecDend.m
% 
% After the pre-parsing, a merged figure can be plotted (used in article):
% 
% plotInputResistanceMERGED.m
%
% 

clear all, close all

% Matlab helper scripts are located here
path(path,'../matlabScripts')


primFile = 'UTDATA/SAVED/LARGEinputResCheck/primInputRes.mat';
secFile = 'UTDATA/SAVED/LARGEinputResCheck/SecDend/secInputRes.mat';

load(primFile)
load(secFile)

figure
            

e(2) = errorbar(nGapsSec, inputResSec*1e-6, ...
                -inputResErrSec*1e-6, inputResErrSec*1e-6, ...
                'k--', 'linewidth', 2, 'color', [0.5 0.5 0.5]);            
hold on

e(1) = errorbar(nGapsPrim, inputResPrim*1e-6, ...
                -inputResErrPrim*1e-6, inputResErrPrim*1e-6, ...
                'k-', 'linewidth', 2, 'color', [0 0 0]);
            

legend(e,'Proximal','Distal')            
            
xlabel('Number of GJ per FS','fontsize',24)
ylabel('Input resistance (M\Omega)','fontsize',24)
set(gca,'fontsize',20)
box off
axis tight
%a = axis; a(1) = 0-0.3; a(3) = 0; axis(a);
a = axis; a(1) = 0-0.3; a(2) = 16+0.03; a(3) = 0; axis(a);

saveas(gcf,'FIGS/FS-inputRes-for-GJ-mean-MERGED.fig','fig')
saveas(gcf,'FIGS/FS-inputRes-for-GJ-mean-MERGED.eps','psc2')
