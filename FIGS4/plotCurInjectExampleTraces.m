% This code just generates two example plots for use in the
% supplementary material.

clear all, close all, format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')

dataPath = 'UTDATA/SAVED/TenFSGJscanCurInject';

randId = 210258410;
gapRes1 = 2.5e9;
gapRes2 = 1e9;

fileMask = '%s/TenInhomoFS-prim-CurInject-GJscan-id%d-gapres-%s-curamp-5.075e-11.data';

data1 = load(sprintf(fileMask,dataPath,randId,num2str(gapRes1)));
data2 = load(sprintf(fileMask,dataPath,randId,num2str(gapRes2)));

tIdx = find(0.5 <= data1(:,1) & data1(:,1) <= 0.9);

figure
subplot(2,1,1)
plot(1e3*data1(tIdx,1)-500,1e3*data1(tIdx,2:end),'k')
box off
ylabel('Volt (mV)','fontsize',24)
set(gca,'fontsize',24)
a = axis; a(3) = -80; a(4) = 50; axis(a);

subplot(2,1,2)
plot(1e3*data2(tIdx,1)-500,1e3*data2(tIdx,2:end),'k')
box off
xlabel('Time (ms)','fontsize',24)
ylabel('Volt (mV)','fontsize',24)
set(gca,'fontsize',20)
a = axis; a(3) = -80; a(4) = 50; axis(a);


saveas(gcf,'FIGS/CurInjectExampleTrace.fig','fig')
saveas(gcf,'FIGS/CurInjectExampleTrace.eps','psc2')
