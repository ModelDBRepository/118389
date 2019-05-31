% Figure S3
%
% Run the following matlab scripts:
% 
% Run simulations:
% runTenInhomoFSGJcorrVariationJITTERSaveGJcur.m
% 
% Read data:
% readTenInhomoFSJITTERWithGJcur.m
%
% Make the frequency curves:
% makeTenInhomoFScorrVarJITTER.m
%
% Make current through GJ figs:
% makeSpikeCenteredGJcurPlotJITTER.m
%
% 

close all

nonCon = find(numGaps == 0);
GJcon = find(numGaps == 15);

randSeedNC = randSeed(nonCon);
randSeedGJ = randSeed(GJcon);

ujitterDt = unique(jitterDt);

% Remove randseeds that are not completed
uRandSeed = setdiff(randSeed, ...
                    setdiff(randSeed, ...
                         intersect(randSeedNC,randSeedGJ)));


cellCtr = ones(length(ujitterDt),1);                     

clear refFreq GJfreq

for uIdx = 1:length(uRandSeed)
  refIdx = find(randSeed == uRandSeed(uIdx) & numGaps == 0);
  GJidx = find(randSeed == uRandSeed(uIdx) & numGaps == 15);
  
  if(isempty(setdiff(ujitterDt, jitterDt(refIdx))) ...
      & isempty(setdiff(ujitterDt, jitterDt(GJidx))))
    % All pMix values are in this run, use it.  

    for jIdx = 1:length(ujitterDt)
      refPidx = refIdx(find(jitterDt(refIdx) == ujitterDt(jIdx)));
      GJPidx = GJidx(find(jitterDt(GJidx) == ujitterDt(jIdx)));
      
      for i=1:numCells(refPidx)
        c = cellCtr(jIdx);
        refFreq(jIdx,c) = firingFreq(refPidx,i);
        GJfreq(jIdx,c) = firingFreq(GJPidx,i);
        cellCtr(jIdx) = c + 1;
      end
    end
  end    
end


meanFreqRef = mean(refFreq,2);
meanFreqGJ = mean(GJfreq,2);
stdMeanFreqRef = std(refFreq,0,2) / sqrt(size(refFreq,2)-1);
stdMeanFreqGJ = std(GJfreq,0,2) / sqrt(size(GJfreq,2)-1);

p(1) = bar(ujitterDt*1e3,meanFreqRef,'r'); hold on
set(p(1),'facecolor',[144 144 254]/255)

p(2) = bar(ujitterDt*1e3,meanFreqGJ,0.65, 'k');
    
z = zeros(size(-stdMeanFreqGJ));

errorbar(ujitterDt*1e3,meanFreqRef,z,stdMeanFreqRef,'k.')
errorbar(ujitterDt*1e3,meanFreqGJ,z,stdMeanFreqGJ, 'k.')
    
legend(p,'Unconnected', ...
         'Gap junction','Location','Best');

xlabel('Jittering (\sigma ms)','FontSize',20)
ylabel('Frequency (Hz)','FontSize',20)
title('Gap junctions filter uncorrelated input','FontSize',24)
set(gca, 'xtick', ujitterDt*1e3)
set(gca, 'fontsize',20)
a = axis; a(1) = -1; a(2) = max(ujitterDt)*1e3+1; axis(a)

box off

saveas(p(1), 'FIGS/FS-freq-GJ-popCorrVarJITTER.fig', 'fig');

figure

px(1) = plot(ujitterDt*1e3,meanFreqRef,'r-','linewidth',2); hold on
px(2) = plot(ujitterDt*1e3,meanFreqGJ,'k-','linewidth',2);
    

errorbar(ujitterDt*1e3,meanFreqRef,-stdMeanFreqRef,stdMeanFreqRef,'k.')
errorbar(ujitterDt*1e3,meanFreqGJ,-stdMeanFreqGJ,stdMeanFreqGJ, 'k.')
    
legend(px,'Unconnected', ...
         'Gap junction','Location','Best');

xlabel('\sigma of jittering (ms)','FontSize',20)
ylabel('Frequency (Hz)','FontSize',20)
title('Gap junctions filter uncorrelated input','FontSize',24)
set(gca, 'xtick', ujitterDt*1e3)
set(gca, 'fontsize',20)
a = axis; a(1) = -1; a(2) = max(ujitterDt)*1e3+1; axis(a)

box off

saveas(px(1), 'FIGS/FS-freq-GJ-popCorrVarJITTER-curves.fig', 'fig');
   
