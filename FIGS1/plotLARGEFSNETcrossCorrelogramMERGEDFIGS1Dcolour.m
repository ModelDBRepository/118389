% This code plots the cross correlogram for the large FS Network
% to compare effect of primary and secondary gap junctions.
% 
%
% This figure uses the same simulation data as 7D and S1B
%
% runLARGEAllUpstateOnlyPrimWrappedNGJscan.m
% runLARGEAllUpstateOnlySecWrappedNGJscan.m
%
%
% First run:
% readLARGEnetOnlyPrimWrappedNGJ.m
% plotLARGEFSNETcrossCorrelogram.m
% readLARGEnetOnlySecWrappedNGJ.m
% plotLARGEFSNETcrossCorrelogram.m
%
% then run
% plotLARGEFSNETcrossCorrelogramMERGED.m

clear all, close all, format compact

primDir = 'UTDATA/SAVED/LARGEFSGJAllUpstateOnlyPrimWrappedNGJscan/';
secDir  = 'UTDATA/SAVED/LARGEFSGJAllUpstateOnlySecWrappedNGJscan/';

prim = load([primDir 'crossCorrData.mat']);
sec  = load([secDir  'crossCorrData.mat']);

primA = load([primDir 'crossCorrDataAllToAll.mat']);
secA  = load([secDir  'crossCorrDataAllToAll.mat']);

%prim10 = load([primDir 'crossCorrDataSize10.mat']);
%sec10  = load([secDir  'crossCorrDataSize10.mat']);

%prim27 = load([primDir 'crossCorrDataSize27.mat']);
%sec27  = load([secDir  'crossCorrDataSize27.mat']);


%plotData = {'p0', 'p4', 'p8', 'p16', ...
%                  's4', 's8', 's16'};
%lineType = {':','-', '--', '-.', ...
%                '-', '--', '-.'};
%lineCol = {[0 0 0], [0 0 0], [0 0 0], [0 0 0], ...
%             0.5*[1 1 1], 0.5*[1 1 1], 0.5*[1 1 1]};

         
%plotData = {'p0', 'p4', 's4', ...
%                  'p8', 's8'};
%lineType = {':','-', '-', ...
%                '--', '--'};
%lineCol = {[0 0 0], [0 0 0], 0.5*[1 1 1], ...
%             0*[1 1 1], 0.5*[1 1 1]};
%
%lineWidth = [2 2 2 ...
%               2 2];
%       
%barCol = [NaN 0.6 0.7 ...
%              0.8 0.9];
%
%

%plotData = {'p4', 's8', 'p12', 'p0'};
%lineType = {'-', '-', '--', '-'};
%lineCol = {[0 0 0], 0.5*[1 1 1], [0 0 0], 0*[1 1 1], };

% p = proximal GJ (only connected)
% P = proximal GJ (all pairs)
% q = proximal GJ (all pairs within sub-networks of size 10)
% r = proximal GJ (all pairs within sub-networks of size 27)
% s = distal GJ (only connected)
% S = distal GJ (all pairs)
% t = distal GJ (all pairs within sub-networks of size 10)
% u = distal GJ (all pairs within sub-networks of size 27)
%plotData = {'p6', 'r6', 'P6', 'p0'};
plotData = {'S4', 'P4', 'P12', 'p0'};

% What kind of line are they drawn with
lineType = {'-', '-', '-', '-'};

colormap('winter');
colA = [0 0 0]; 
colB = interp1(linspace(0,1,64),colormap,0);
colC = interp1(linspace(0,1,64),colormap,0.5);
colD = interp1(linspace(0,1,64),colormap,1);

lineCol = {colB, colC, colD, colA, };
lineWidth = [2 2 2 1];
       
% Should the bars be filled, with what colour?
barCol = [colB ; colC; colD; NaN NaN NaN];

% Should we permute the order of the legend items?
legPermut = [4 1 2 3];      


clear pLeg

for i=1:length(plotData)
  
  if(plotData{i}(1) == 'p')
    data{i} = prim;
    GJloc = 'Prox GJ (direct)';
    nGJ = str2num(plotData{i}(2:end));
  elseif(plotData{i}(1) == 's')
    data{i} = sec;
    GJloc = 'Dist GJ (direct)';
    nGJ = str2num(plotData{i}(2:end));
  elseif(plotData{i}(1) == 'P')
    data{i} = primA;
%    GJloc = 'Prox GJ (all)';
    GJloc = 'Prox GJ';
    nGJ = str2num(plotData{i}(2:end));
  elseif(plotData{i}(1) == 'S')
    data{i} = secA;
%    GJloc = 'Dist GJ (all)';
    GJloc = 'Dist GJ';
    nGJ = str2num(plotData{i}(2:end));
  elseif(plotData{i}(1) == 'q')
    data{i} = prim10;
    GJloc = 'Prox GJ (10 subnet)';
    nGJ = str2num(plotData{i}(2:end));
  elseif(plotData{i}(1) == 't')
    data{i} = sec10;
    GJloc = 'Dist GJ (10 subnet)';
    nGJ = str2num(plotData{i}(2:end));
  elseif(plotData{i}(1) == 'r')
    data{i} = prim27;
    GJloc = 'Prox GJ (27 subnet)';
    nGJ = str2num(plotData{i}(2:end));
  elseif(plotData{i}(1) == 'u')
    data{i} = sec27;
    GJloc = 'Dist GJ (27 subnet)';
    nGJ = str2num(plotData{i}(2:end));
  else
    disp('Unknown data')
    keyboard
  end


  idx(i) = find(nGJ == data{i}.nGJ);

  hold on

  if(~isnan(barCol(i,1)))
    tmp = bar(data{i}.ccEdges*1e3, data{i}.meanCC{idx(i)},'histc');
    set(tmp,'facecolor', barCol(i,:),'edgecolor',barCol(i,:));
  end  
    
  if(nGJ == 0)
    pLeg{i} = 'Unconnected';
  else
    pLeg{i} = sprintf('%d %s', nGJ, GJloc);
  end
end

for i=length(data):-1:1
  p(i) = stairs(data{i}.ccEdges*1e3, data{i}.meanCC{idx(i)}, ...
                lineType{i},'color',lineCol{i}, 'lineWidth', lineWidth(i));
          
end


leg = legend(p(legPermut),pLeg(legPermut));
set(leg,'position',get(leg,'position')+[0.05 0 0 0])

xlabel('Time (ms)', 'fontsize', 24)
ylabel('Occurances (s^{-1})', 'fontsize', 24)
set(gca,'fontsize',20)
box off

a = axis;
a(1) = -50; a(2) = 50; a(3) = 0;
axis(a);


saveas(gcf,'FIGS/LARGEFS-crossCorrelogram-MERGED-FigS1Dcolour.fig','fig')
saveas(gcf,'FIGS/LARGEFS-crossCorrelogram-MERGED-FigS1Dcolour.eps','psc2')


