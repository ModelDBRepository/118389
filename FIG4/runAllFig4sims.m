%
% The purpose of this script is to regenerate all graphs should it be needed
% It also serves the purpose of helping me keep track of what I
% did... ;)

clear all, close all

% Matlab helper scripts are located here
path(path,'../matlabScripts')

% Genesis model is located here
path(path,'../genesisScripts')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1, Figure 4A
% Synaptic input to cell A, no input to cell B
% Cell A spikes, but when GJ are added no spikes.

% Non-connected
system('genesis runSimForFIG4A-NC.g');

% GJ connected
system('genesis runSimForFIG4A-GJ.g');
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2, Figure 4B
% Synaptic inpute makes cell A spike, but not cell B
% with GJ A triggers spike in B which were close to threshold before

% Non-connected
system('genesis runSimForFIG4B-NC.g');

% GJ connected
system('genesis runSimForFIG4B-GJ.g');

% Step 3, Figure 4C
% Synaptic makes neither spike alone, but with GJ they can
%


% Non-connected
system('genesis runSimForFIG4C-NC.g');

% GJ connected
system('genesis runSimForFIG4C-GJ.g');


% ALT fig or extra fig

system('genesis runSimForFIG4-NC-test0to2.g');
system('genesis runSimForFIG4C-GJ-test0to2.g');

% Load and plot

dAnc = load('UTDATA/TWOFS-FIG4A-NC.data');
dAgj = load('UTDATA/TWOFS-FIG4A-GJ.data');

dBnc = load('UTDATA/TWOFS-FIG4B-NC.data');
dBgj = load('UTDATA/TWOFS-FIG4B-GJ.data');

dCnc = load('UTDATA/TWOFS-FIG4C-NC.data');
dCgj = load('UTDATA/TWOFS-FIG4C-GJ.data');

dDnc = load('UTDATA/TWOFS-FIG4-NC-0to2.data');
dDgj = load('UTDATA/TWOFS-FIG4-GJ-0to2.data');

p(1:2) = plotFigs(dAnc,dAgj);
p(3:4) = plotFigs(dBnc,dBgj);
p(5:6) = plotFigs(dCnc,dCgj);
p(7:8) = plotFigs(dDnc,dDgj);

% Save all figures

saveas(p(1), 'FIGS/FIG4-TraceA-NC.fig','fig');
saveas(p(2), 'FIGS/FIG4-TraceA-GJ.fig','fig');
saveas(p(3), 'FIGS/FIG4-TraceB-NC.fig','fig');
saveas(p(4), 'FIGS/FIG4-TraceB-GJ.fig','fig');
saveas(p(5), 'FIGS/FIG4-TraceC-NC.fig','fig');
saveas(p(6), 'FIGS/FIG4-TraceC-GJ.fig','fig');
saveas(p(7), 'FIGS/FIG4-TraceD-NC.fig','fig');
saveas(p(8), 'FIGS/FIG4-TraceD-GJ.fig','fig');

saveas(p(1), 'FIGS/FIG4-TraceA-NC.eps','psc2');
saveas(p(2), 'FIGS/FIG4-TraceA-GJ.eps','psc2');
saveas(p(3), 'FIGS/FIG4-TraceB-NC.eps','psc2');
saveas(p(4), 'FIGS/FIG4-TraceB-GJ.eps','psc2');
saveas(p(5), 'FIGS/FIG4-TraceC-NC.eps','psc2');
saveas(p(6), 'FIGS/FIG4-TraceC-GJ.eps','psc2');
saveas(p(7), 'FIGS/FIG4-TraceD-NC.eps','psc2');
saveas(p(8), 'FIGS/FIG4-TraceD-GJ.eps','psc2');
