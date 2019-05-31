% This code takes the already datafiles from SobolFSsynch

clear all, close all

disp('Reading Na-data')
dataNa(1) = load('UTDATA/SAVED/fromSpike/SpikeSynchDataNah.mat');
dataNa(2) = load('UTDATA/SAVED/fromMulder/SpikeSynchDataNah.mat');
dataNa(3) = load('UTDATA/SAVED/fromSpike2/SpikeSynchDataNah.mat');

disp('Reading Kv3132-data')
dataKv3132(1) = load('UTDATA/SAVED/fromSpike/SpikeSynchDataKv3132.mat');
dataKv3132(2) = load('UTDATA/SAVED/fromMulder/SpikeSynchDataKv3132.mat');

disp('Reading Kv13-data')
dataKv13(1) = load('UTDATA/SAVED/fromSpike/SpikeSynchDataK13.mat');
dataKv13(2) = load('UTDATA/SAVED/fromMulder/SpikeSynchDataK13.mat');

disp('Reading KAm-data')
dataKAm(1) = load('UTDATA/SAVED/fromMulder/SpikeSynchDataKAm.mat');
dataKAm(2) = load('UTDATA/SAVED/fromSaga/SpikeSynchDataKAm.mat');
dataKAm(3) = load('UTDATA/SAVED/fromSaga2/SpikeSynchDataKAm.mat');

disp('Reading KAh-data')
dataKAh(1) = load('UTDATA/SAVED/fromMulder/SpikeSynchDataKAh.mat');
dataKAh(2) = load('UTDATA/SAVED/fromSaga/SpikeSynchDataKAh.mat');
dataKAh(2) = load('UTDATA/SAVED/fromSaga2/SpikeSynchDataKAh.mat');


%% Kolla KA strömmen också

disp('Add code for KA (m and h-particles)')

maxTime = 1000;
tShuffle = pi; % arbitrary shuffle time

tMin = -0.1; tMax = 0.1;
tEdges = linspace(tMin,tMax,100);

disp('Processing Na')

for i=1:length(dataNa)
   if(nnz(dataNa(i).spikeTimesRef{1}(:,1) > maxTime))
     disp('Incorrect maxTime!!')
     return
   end
    
   tDiffRef = ...
       repmat(dataNa(i).spikeTimesRef{1}, ...
              1, length(dataNa(i).spikeTimesRef{2})) ...
       - repmat(dataNa(i).spikeTimesRef{2}', ...
                length(dataNa(i).spikeTimesRef{1}),1);
   dataNa(i).nRef = histc(tDiffRef(:),tEdges);
   clear tDiffRef
   
   tDiffMod1 = ...
       repmat(dataNa(i).spikeTimesMod1{1}, ...
              1, length(dataNa(i).spikeTimesMod1{2})) ...
       - repmat(dataNa(i).spikeTimesMod1{2}', ...
                length(dataNa(i).spikeTimesMod1{1}),1);
   dataNa(i).nMod1 = histc(tDiffMod1(:),tEdges);
   clear tDiffMod1
   
   tDiffMod2 = ...
       repmat(dataNa(i).spikeTimesMod2{1}, ...
              1, length(dataNa(i).spikeTimesMod2{2})) ...
       - repmat(dataNa(i).spikeTimesMod2{2}', ...
                length(dataNa(i).spikeTimesMod2{1}),1);
   dataNa(i).nMod2 = histc(tDiffMod2(:),tEdges);
   clear tDiffMod2
   
   % Shuffled traces
   tDiffRefShuf = ...
       repmat(mod(dataNa(i).spikeTimesRef{1}+tShuffle,maxTime), ...
              1, length(dataNa(i).spikeTimesRef{2})) ...
       - repmat(dataNa(i).spikeTimesRef{2}', ...
                length(dataNa(i).spikeTimesRef{1}),1);
   dataNa(i).nRefS = histc(tDiffRefShuf(:),tEdges);
   clear tDiffRefShuf
   
   tDiffMod1Shuf = ...
       repmat(mod(dataNa(i).spikeTimesMod1{1}+tShuffle,maxTime), ...
              1, length(dataNa(i).spikeTimesMod1{2})) ...
       - repmat(dataNa(i).spikeTimesMod1{2}', ...
                length(dataNa(i).spikeTimesMod1{1}),1);
   dataNa(i).nMod1S = histc(tDiffMod1Shuf(:),tEdges);
   clear tDiffMod1Shuf
   
   tDiffMod2Shuf = ...
       repmat(mod(dataNa(i).spikeTimesMod2{1}+tShuffle,maxTime), ...
              1, length(dataNa(i).spikeTimesMod2{2})) ...
       - repmat(dataNa(i).spikeTimesMod2{2}', ...
                length(dataNa(i).spikeTimesMod2{1}),1);
   dataNa(i).nMod2S = histc(tDiffMod2Shuf(:),tEdges);
   clear tDiffMod2Shuf
   
            
end

disp('Processing Kv3.1/3.2')

for i=1:length(dataKv3132)
   if(nnz(dataKv3132(i).spikeTimesRef{1}(:,1) > maxTime))
     disp('Incorrect maxTime!!')
     return
   end
    
   tDiffRef = ...
       repmat(dataKv3132(i).spikeTimesRef{1}, ...
              1, length(dataKv3132(i).spikeTimesRef{2})) ...
       - repmat(dataKv3132(i).spikeTimesRef{2}', ...
                length(dataKv3132(i).spikeTimesRef{1}),1);
   dataKv3132(i).nRef = histc(tDiffRef(:),tEdges);
   clear tDiffRef
   
   tDiffMod1 = ...
       repmat(dataKv3132(i).spikeTimesMod1{1}, ...
              1, length(dataKv3132(i).spikeTimesMod1{2})) ...
       - repmat(dataKv3132(i).spikeTimesMod1{2}', ...
                length(dataKv3132(i).spikeTimesMod1{1}),1);
   dataKv3132(i).nMod1 = histc(tDiffMod1(:),tEdges);
   clear tDiffMod1
   
   tDiffMod2 = ...
       repmat(dataKv3132(i).spikeTimesMod2{1}, ...
              1, length(dataKv3132(i).spikeTimesMod2{2})) ...
       - repmat(dataKv3132(i).spikeTimesMod2{2}', ...
                length(dataKv3132(i).spikeTimesMod2{1}),1);
   dataKv3132(i).nMod2 = histc(tDiffMod2(:),tEdges);
   clear tDiffMod2
   
   % Shuffled traces
   tDiffRefShuf = ...
       repmat(mod(dataKv3132(i).spikeTimesRef{1}+tShuffle,maxTime), ...
              1, length(dataKv3132(i).spikeTimesRef{2})) ...
       - repmat(dataKv3132(i).spikeTimesRef{2}', ...
                length(dataKv3132(i).spikeTimesRef{1}),1);
   dataKv3132(i).nRefS = histc(tDiffRefShuf(:),tEdges);
   clear tDiffRefShuf
   
   tDiffMod1Shuf = ...
       repmat(mod(dataKv3132(i).spikeTimesMod1{1}+tShuffle,maxTime), ...
              1, length(dataKv3132(i).spikeTimesMod1{2})) ...
       - repmat(dataKv3132(i).spikeTimesMod1{2}', ...
                length(dataKv3132(i).spikeTimesMod1{1}),1);
   dataKv3132(i).nMod1S = histc(tDiffMod1Shuf(:),tEdges);
   clear tDiffMod1Shuf
   
   tDiffMod2Shuf = ...
       repmat(mod(dataKv3132(i).spikeTimesMod2{1}+tShuffle,maxTime), ...
              1, length(dataKv3132(i).spikeTimesMod2{2})) ...
       - repmat(dataKv3132(i).spikeTimesMod2{2}', ...
                length(dataKv3132(i).spikeTimesMod2{1}),1);
   dataKv3132(i).nMod2S = histc(tDiffMod2Shuf(:),tEdges);
   clear tDiffMod2Shuf
   
            
end

disp('Processing Kv1.3')

for i=1:length(dataKv13)
   if(nnz(dataKv13(i).spikeTimesRef{1}(:,1) > maxTime))
     disp('Incorrect maxTime!!')
     return
   end
    
   tDiffRef = ...
       repmat(dataKv13(i).spikeTimesRef{1}, ...
              1, length(dataKv13(i).spikeTimesRef{2})) ...
       - repmat(dataKv13(i).spikeTimesRef{2}', ...
                length(dataKv13(i).spikeTimesRef{1}),1);
   dataKv13(i).nRef = histc(tDiffRef(:),tEdges);
   clear tDiffRef
   
   tDiffMod1 = ...
       repmat(dataKv13(i).spikeTimesMod1{1}, ...
              1, length(dataKv13(i).spikeTimesMod1{2})) ...
       - repmat(dataKv13(i).spikeTimesMod1{2}', ...
                length(dataKv13(i).spikeTimesMod1{1}),1);
   dataKv13(i).nMod1 = histc(tDiffMod1(:),tEdges);
   clear tDiffMod1
   
   tDiffMod2 = ...
       repmat(dataKv13(i).spikeTimesMod2{1}, ...
              1, length(dataKv13(i).spikeTimesMod2{2})) ...
       - repmat(dataKv13(i).spikeTimesMod2{2}', ...
                length(dataKv13(i).spikeTimesMod2{1}),1);
   dataKv13(i).nMod2 = histc(tDiffMod2(:),tEdges);
   clear tDiffMod2
   
   % Shuffled traces
   tDiffRefShuf = ...
       repmat(mod(dataKv13(i).spikeTimesRef{1}+tShuffle,maxTime), ...
              1, length(dataKv13(i).spikeTimesRef{2})) ...
       - repmat(dataKv13(i).spikeTimesRef{2}', ...
                length(dataKv13(i).spikeTimesRef{1}),1);
   dataKv13(i).nRefS = histc(tDiffRefShuf(:),tEdges);
   clear tDiffRefShuf
   
   tDiffMod1Shuf = ...
       repmat(mod(dataKv13(i).spikeTimesMod1{1}+tShuffle,maxTime), ...
              1, length(dataKv13(i).spikeTimesMod1{2})) ...
       - repmat(dataKv13(i).spikeTimesMod1{2}', ...
                length(dataKv13(i).spikeTimesMod1{1}),1);
   dataKv13(i).nMod1S = histc(tDiffMod1Shuf(:),tEdges);
   clear tDiffMod1Shuf
   
   tDiffMod2Shuf = ...
       repmat(mod(dataKv13(i).spikeTimesMod2{1}+tShuffle,maxTime), ...
              1, length(dataKv13(i).spikeTimesMod2{2})) ...
       - repmat(dataKv13(i).spikeTimesMod2{2}', ...
                length(dataKv13(i).spikeTimesMod2{1}),1);
   dataKv13(i).nMod2S = histc(tDiffMod2Shuf(:),tEdges);
   clear tDiffMod2Shuf
   
            
end

%%%%%%%%%%%%

disp('Processing KA (m)')

for i=1:length(dataKAm)
   if(nnz(dataKAm(i).spikeTimesRef{1}(:,1) > maxTime))
     disp('Incorrect maxTime!!')
     return
   end
    
   tDiffRef = ...
       repmat(dataKAm(i).spikeTimesRef{1}, ...
              1, length(dataKAm(i).spikeTimesRef{2})) ...
       - repmat(dataKAm(i).spikeTimesRef{2}', ...
                length(dataKAm(i).spikeTimesRef{1}),1);
   dataKAm(i).nRef = histc(tDiffRef(:),tEdges);
   clear tDiffRef
   
   tDiffMod1 = ...
       repmat(dataKAm(i).spikeTimesMod1{1}, ...
              1, length(dataKAm(i).spikeTimesMod1{2})) ...
       - repmat(dataKAm(i).spikeTimesMod1{2}', ...
                length(dataKAm(i).spikeTimesMod1{1}),1);
   dataKAm(i).nMod1 = histc(tDiffMod1(:),tEdges);
   clear tDiffMod1
   
   tDiffMod2 = ...
       repmat(dataKAm(i).spikeTimesMod2{1}, ...
              1, length(dataKAm(i).spikeTimesMod2{2})) ...
       - repmat(dataKAm(i).spikeTimesMod2{2}', ...
                length(dataKAm(i).spikeTimesMod2{1}),1);
   dataKAm(i).nMod2 = histc(tDiffMod2(:),tEdges);
   clear tDiffMod2
   
   % Shuffled traces
   tDiffRefShuf = ...
       repmat(mod(dataKAm(i).spikeTimesRef{1}+tShuffle,maxTime), ...
              1, length(dataKAm(i).spikeTimesRef{2})) ...
       - repmat(dataKAm(i).spikeTimesRef{2}', ...
                length(dataKAm(i).spikeTimesRef{1}),1);
   dataKAm(i).nRefS = histc(tDiffRefShuf(:),tEdges);
   clear tDiffRefShuf
   
   tDiffMod1Shuf = ...
       repmat(mod(dataKAm(i).spikeTimesMod1{1}+tShuffle,maxTime), ...
              1, length(dataKAm(i).spikeTimesMod1{2})) ...
       - repmat(dataKAm(i).spikeTimesMod1{2}', ...
                length(dataKAm(i).spikeTimesMod1{1}),1);
   dataKAm(i).nMod1S = histc(tDiffMod1Shuf(:),tEdges);
   clear tDiffMod1Shuf
   
   tDiffMod2Shuf = ...
       repmat(mod(dataKAm(i).spikeTimesMod2{1}+tShuffle,maxTime), ...
              1, length(dataKAm(i).spikeTimesMod2{2})) ...
       - repmat(dataKAm(i).spikeTimesMod2{2}', ...
                length(dataKAm(i).spikeTimesMod2{1}),1);
   dataKAm(i).nMod2S = histc(tDiffMod2Shuf(:),tEdges);
   clear tDiffMod2Shuf
   
            
end



disp('Processing KA (h)')

for i=1:length(dataKAh)
   if(nnz(dataKAh(i).spikeTimesRef{1}(:,1) > maxTime))
     disp('Incorrect maxTime!!')
     return
   end
    
   tDiffRef = ...
       repmat(dataKAh(i).spikeTimesRef{1}, ...
              1, length(dataKAh(i).spikeTimesRef{2})) ...
       - repmat(dataKAh(i).spikeTimesRef{2}', ...
                length(dataKAh(i).spikeTimesRef{1}),1);
   dataKAh(i).nRef = histc(tDiffRef(:),tEdges);
   clear tDiffRef
   
   tDiffMod1 = ...
       repmat(dataKAh(i).spikeTimesMod1{1}, ...
              1, length(dataKAh(i).spikeTimesMod1{2})) ...
       - repmat(dataKAh(i).spikeTimesMod1{2}', ...
                length(dataKAh(i).spikeTimesMod1{1}),1);
   dataKAh(i).nMod1 = histc(tDiffMod1(:),tEdges);
   clear tDiffMod1
   
   tDiffMod2 = ...
       repmat(dataKAh(i).spikeTimesMod2{1}, ...
              1, length(dataKAh(i).spikeTimesMod2{2})) ...
       - repmat(dataKAh(i).spikeTimesMod2{2}', ...
                length(dataKAh(i).spikeTimesMod2{1}),1);
   dataKAh(i).nMod2 = histc(tDiffMod2(:),tEdges);
   clear tDiffMod2
   
   % Shuffled traces
   tDiffRefShuf = ...
       repmat(mod(dataKAh(i).spikeTimesRef{1}+tShuffle,maxTime), ...
              1, length(dataKAh(i).spikeTimesRef{2})) ...
       - repmat(dataKAh(i).spikeTimesRef{2}', ...
                length(dataKAh(i).spikeTimesRef{1}),1);
   dataKAh(i).nRefS = histc(tDiffRefShuf(:),tEdges);
   clear tDiffRefShuf
   
   tDiffMod1Shuf = ...
       repmat(mod(dataKAh(i).spikeTimesMod1{1}+tShuffle,maxTime), ...
              1, length(dataKAh(i).spikeTimesMod1{2})) ...
       - repmat(dataKAh(i).spikeTimesMod1{2}', ...
                length(dataKAh(i).spikeTimesMod1{1}),1);
   dataKAh(i).nMod1S = histc(tDiffMod1Shuf(:),tEdges);
   clear tDiffMod1Shuf
   
   tDiffMod2Shuf = ...
       repmat(mod(dataKAh(i).spikeTimesMod2{1}+tShuffle,maxTime), ...
              1, length(dataKAh(i).spikeTimesMod2{2})) ...
       - repmat(dataKAh(i).spikeTimesMod2{2}', ...
                length(dataKAh(i).spikeTimesMod2{1}),1);
   dataKAh(i).nMod2S = histc(tDiffMod2Shuf(:),tEdges);
   clear tDiffMod2Shuf
   
            
end






% Merge cross correlograms, and do shuffle correction

nRefCorrNa  = zeros(size(tEdges'));
nMod1CorrNa = zeros(size(tEdges'));
nMod2CorrNa = zeros(size(tEdges'));

disp('Merging data')

for i=1:length(dataNa)
  nRefCorrNa = nRefCorrNa + dataNa(i).nRef - dataNa(i).nRefS;
  nMod1CorrNa = nMod1CorrNa + dataNa(i).nMod1 - dataNa(i).nMod1S;
  nMod2CorrNa = nMod2CorrNa + dataNa(i).nMod2 - dataNa(i).nMod2S;
end

disp('Plotting')

figure, hold on
p(3) = stairs(tEdges(1:end-1)*1e3, ...
              nMod2CorrNa(1:end-1), ...
              'r-', 'linewidth',2);
          
p(1) = stairs(tEdges(1:end-1)*1e3, ...
              nRefCorrNa(1:end-1), ...
              'k-', 'linewidth',2);
          
p(2) = stairs(tEdges(1:end-1)*1e3, ...
              nMod1CorrNa(1:end-1), ...
              'b-', 'linewidth',2);

box off
xlabel('Time difference (ms)','fontsize',20)
ylabel('Count','fontsize',20)
set(gca,'fontsize',20)
axis tight
a = axis; a(1) = tMin*1e3; a(2) = tMax*1e3; axis(a);
legend(p,'Reference','-20% \tau_h (Na)','+20% \tau_h (Na)', ...
         'location','northeast')
       
saveas(gcf,'FIGS/SCCC-Na-mod.eps','psc2')     

nRefCorrKv3132  = zeros(size(tEdges'));
nMod1CorrKv3132 = zeros(size(tEdges'));
nMod2CorrKv3132 = zeros(size(tEdges'));

for i=1:length(dataKv3132)
  nRefCorrKv3132 = nRefCorrKv3132 + dataKv3132(i).nRef - dataKv3132(i).nRefS;
  nMod1CorrKv3132 = nMod1CorrKv3132 + dataKv3132(i).nMod1 -dataKv3132(i).nMod1S;
  nMod2CorrKv3132 = nMod2CorrKv3132 + dataKv3132(i).nMod2 -dataKv3132(i).nMod2S;
end

figure, hold on
p(3) = stairs(tEdges(1:end-1)*1e3, ...
              nMod2CorrKv3132(1:end-1), ...
              'r-', 'linewidth',2);
          
p(1) = stairs(tEdges(1:end-1)*1e3, ...
              nRefCorrKv3132(1:end-1), ...
              'k-', 'linewidth',2);
          
p(2) = stairs(tEdges(1:end-1)*1e3, ...
              nMod1CorrKv3132(1:end-1), ...
              'b-', 'linewidth',2);

box off
xlabel('Time difference (ms)','fontsize',20)
ylabel('Count','fontsize',20)
set(gca,'fontsize',20)
axis tight
a = axis; a(1) = tMin*1e3; a(2) = tMax*1e3; axis(a);
legend(p,'Reference', ...
         '-20% \tau_h (Kv_{3.1/3.2})', ...
         '+20% \tau_h (Kv_{3.1/3.2})', ...
         'location','northeast')
       
saveas(gcf,'FIGS/SCCC-Kv3132-mod.eps','psc2')  


nRefCorrKv13  = zeros(size(tEdges'));
nMod1CorrKv13 = zeros(size(tEdges'));
nMod2CorrKv13 = zeros(size(tEdges'));

for i=1:length(dataKv13)
  nRefCorrKv13 = nRefCorrKv13 + dataKv13(i).nRef - dataKv13(i).nRefS;
  nMod1CorrKv13 = nMod1CorrKv13 + dataKv13(i).nMod1 - dataKv13(i).nMod1S;
  nMod2CorrKv13 = nMod2CorrKv13 + dataKv13(i).nMod2 - dataKv13(i).nMod2S;
end

figure, hold on
p(3) = stairs(tEdges(1:end-1)*1e3, ...
              nMod2CorrKv13(1:end-1), ...
              'r-', 'linewidth',2);
          
p(1) = stairs(tEdges(1:end-1)*1e3, ...
              nRefCorrKv13(1:end-1), ...
              'k-', 'linewidth',2);
          
p(2) = stairs(tEdges(1:end-1)*1e3, ...
              nMod1CorrKv13(1:end-1), ...
              'b-', 'linewidth',2);

box off
xlabel('Time difference (ms)','fontsize',20)
ylabel('Count','fontsize',20)
set(gca,'fontsize',20)
axis tight
a = axis; a(1) = tMin*1e3; a(2) = tMax*1e3; axis(a);
legend(p,'Reference', ...
         '-20% \tau_h (Kv_{1.3})', ...
         '+20% \tau_h (Kv_{1.3})', ...
         'location','northeast')
       
saveas(gcf,'FIGS/SCCC-Kv13-mod.eps','psc2')  





%%%%%%%%%%%%%%%%%%%%%



nRefCorrKAm  = zeros(size(tEdges'));
nMod1CorrKAm = zeros(size(tEdges'));
nMod2CorrKAm = zeros(size(tEdges'));

for i=1:length(dataKAm)
  nRefCorrKAm = nRefCorrKAm + dataKAm(i).nRef - dataKAm(i).nRefS;
  nMod1CorrKAm = nMod1CorrKAm + dataKAm(i).nMod1 - dataKAm(i).nMod1S;
  nMod2CorrKAm = nMod2CorrKAm + dataKAm(i).nMod2 - dataKAm(i).nMod2S;
end

figure, hold on
p(3) = stairs(tEdges(1:end-1)*1e3, ...
              nMod2CorrKAm(1:end-1), ...
              'r-', 'linewidth',2);
          
p(1) = stairs(tEdges(1:end-1)*1e3, ...
              nRefCorrKAm(1:end-1), ...
              'k-', 'linewidth',2);
          
p(2) = stairs(tEdges(1:end-1)*1e3, ...
              nMod1CorrKAm(1:end-1), ...
              'b-', 'linewidth',2);

box off
xlabel('Time difference (ms)','fontsize',20)
ylabel('Count','fontsize',20)
set(gca,'fontsize',20)
axis tight
a = axis; a(1) = tMin*1e3; a(2) = tMax*1e3; axis(a);
legend(p,'Reference', ...
         '-20% \tau_m (KA)', ...
         '+20% \tau_m (KA)', ...
         'location','northeast')
       
saveas(gcf,'FIGS/SCCC-KAm-mod.eps','psc2')  





nRefCorrKAh  = zeros(size(tEdges'));
nMod1CorrKAh = zeros(size(tEdges'));
nMod2CorrKAh = zeros(size(tEdges'));

for i=1:length(dataKAh)
  nRefCorrKAh = nRefCorrKAh + dataKAh(i).nRef - dataKAh(i).nRefS;
  nMod1CorrKAh = nMod1CorrKAh + dataKAh(i).nMod1 - dataKAh(i).nMod1S;
  nMod2CorrKAh = nMod2CorrKAh + dataKAh(i).nMod2 - dataKAh(i).nMod2S;
end

figure, hold on
p(3) = stairs(tEdges(1:end-1)*1e3, ...
              nMod2CorrKAh(1:end-1), ...
              'r-', 'linewidth',2);
          
p(1) = stairs(tEdges(1:end-1)*1e3, ...
              nRefCorrKAh(1:end-1), ...
              'k-', 'linewidth',2);
          
p(2) = stairs(tEdges(1:end-1)*1e3, ...
              nMod1CorrKAh(1:end-1), ...
              'b-', 'linewidth',2);

box off
xlabel('Time difference (ms)','fontsize',20)
ylabel('Count','fontsize',20)
set(gca,'fontsize',20)
axis tight
a = axis; a(1) = tMin*1e3; a(2) = tMax*1e3; axis(a);
legend(p,'Reference', ...
         '-20% \tau_h (KA)', ...
         '+20% \tau_h (KA)', ...
         'location','northeast')
       
saveas(gcf,'FIGS/SCCC-KAh-mod.eps','psc2')  






