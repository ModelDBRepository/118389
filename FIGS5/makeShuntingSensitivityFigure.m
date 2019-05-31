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
% This code shows how the shunting is affected by various parameter
% changes for the channels.
%

clear all, close all

cv = load('TenFS-BlueGene.mat');

barCol = hsv(10);
      
barCol = barCol([1:3:10, 2:3:10, 3:3:10],:);

%barCol = repmat([1 1 1 ; 0.5 0.5 0.5],5,1);
barCol = repmat([1 1 1],10,1);

figure
plot([0 21],cv.meanFreqRefPAR([21 21]),'k--'), hold on
plot([0 21],cv.meanFreqGJPAR([21 21]),'k-'), hold on

for i=1:10
  plotIdx = [i*2-1,i*2];
  p(i) = bar(plotIdx + [0.1 -0.1],cv.meanFreqRefPAR(plotIdx),0.85,'r'); hold on
  bar(plotIdx+[0.1 -0.1],cv.meanFreqGJPAR(plotIdx),0.6,'k');
  set(p(i),'facecolor',barCol(i,:));
  text(plotIdx(1)-0.15, cv.meanFreqRefPAR(plotIdx(1))-0.3, '+','fontsize',15)
  text(plotIdx(2)-0.35, cv.meanFreqRefPAR(plotIdx(2))-0.3, '-','fontsize',15)
end

pLeg = {'g_{Na}', 'g_{KA}', 'g_{Kv3.1/3.2}', 'g_{K1.3}', ...
        '\tau_{m Na}', '\tau_{h Na}', '\tau_{m KA}', '\tau_{h KA}', ...
        '\tau_{Kv3.1/3.2}', '\tau_{Kv1.3}'};
    

%legend(p,pLeg,'location','eastoutside')
  
ylabel('Frequency (Hz)','fontsize',16)
set(gca,'fontsize',16)
%set(gca,'xtick',[])

for i=1:10
xLab{i} = num2str(i); 
end

set(gca,'xtick',1.5:2:21,'xticklabel',xLab)
axis tight
a = axis; a(1) = a(1) - 0.3; axis(a);

box off
saveas(gcf,'FIGS/TenFS-sense-meanFreq-updated.fig','fig')
saveas(gcf,'FIGS/TenFS-sense-meanFreq-updated.eps','psc2')

%%%%% Same as above, but not all columns

figure
idx = [1:2, 5:8]

plot([0 13],cv.meanFreqRefPAR([21 21]),'k--'), hold on
plot([0 13],cv.meanFreqGJPAR([21 21]),'k-'), hold on

xCoord = 1;

p = [];

for i=idx
  plotIdx = [i*2-1,i*2];
  p(end + 1) = bar(xCoord + [0 1] + [0.1 -0.1],cv.meanFreqRefPAR(plotIdx),0.85,'r'); hold on
  bar(xCoord + [0 1] +[0.1 -0.1],cv.meanFreqGJPAR(plotIdx),0.6,'k');
  set(p(end),'facecolor',barCol(i,:));
  text(xCoord-0.15+0.1, cv.meanFreqRefPAR(plotIdx(1))-0.3, '+','fontsize',15)
  text(xCoord+1-0.35+0.1, cv.meanFreqRefPAR(plotIdx(2))-0.3, '-','fontsize',15)

  xCoord = xCoord + 2;
end

pLeg = {'g_{Na}', 'g_{KA}', 'g_{Kv3.1/3.2}', 'g_{K1.3}', ...
        '\tau_{m,Na}', '\tau_{h,Na}', '\tau_{m,KA}', '\tau_{h,KA}', ...
        '\tau_{Kv3.1/3.2}', '\tau_{Kv1.3}'};
    

%legend(p,pLeg(idx),'location','eastoutside')
  
ylabel('Frequency (Hz)','fontsize',16)
set(gca,'fontsize',16)
%set(gca,'xtick',[])

%for i=1:length(idx)
%  xLab{i} = pLeg{idx(i)};
%end

%xLab = {'gNa','gKA','TauM-Na','TauH-Na','Tau-M KA','Tau-H KA'}
set(gca,'xtick', []);
for i=1:6
  text(2*i-1,-1,pLeg{idx(i)},'fontsize',16) 
end

%set(gca,'xtick',1.5:2:12,'xticklabel',xLab)
axis tight
a = axis; a(1) = a(1) - 0.3; axis(a);

box off
saveas(gcf,'FIGS/TenFS-sense-meanFreq-updated-selection.fig','fig')
saveas(gcf,'FIGS/TenFS-sense-meanFreq-updated-selection.eps','psc2')




%%%%%% Show the relative shunting also

figure
plot([0 21],cv.shuntMean([21 21]),'k--'), hold on
plot(21-0.1,cv.shuntMean(21)+cv.shuntStd([21 21]),'k.'), hold on

for i=1:10
  plotIdx = [i*2-1,i*2];
  p(i) = bar(plotIdx + [0.1 -0.1],cv.shuntMean(plotIdx),0.8,'r'); hold on
  errorbar(plotIdx + [0.1 -0.1],cv.shuntMean(plotIdx), ...
           -cv.shuntStd(plotIdx),cv.shuntStd(plotIdx),'k.')
%  set(p(i),'facecolor',barCol(i,:));
  set(p(i),'facecolor',[0.7 0.7 0.7]);
  text(plotIdx(1)-0.15, cv.shuntMean(plotIdx(1))-0.05, '+','fontsize',15)
  text(plotIdx(2)-0.35, cv.shuntMean(plotIdx(2))-0.05, '-','fontsize',15)
%  text(plotIdx(1)-0.15, 0.5, '+','fontsize',15)
%  text(plotIdx(2)-0.35, 0.5, '-','fontsize',15)
end

%legend(p,pLeg,'location','eastoutside')
  
ylabel('Frequency (Hz)','fontsize',16)
set(gca,'fontsize',16)
%set(gca,'xtick',[])

for i=1:10
xLab{i} = num2str(i); 
end

set(gca,'xtick',1.5:2:21,'xticklabel',xLab)
axis tight
a = axis; a(1) = a(1) - 0.3; axis(a);

box off
saveas(gcf,'FIGS/TenFS-sense-shunting-updated.fig','fig')
saveas(gcf,'FIGS/TenFS-sense-shunting-updated.eps','psc2')




