% Run the script to generate data for the figures:
%
% runTenInhomoFSGJcorrVariationSaveGJcur.m
% readTenInhomoFScorrVarWithGJcur.m
% 
% To make figure 5B:
% makeTenInhomoFScorrVar.m
% 
% To make figure 5C:
% makeSpikeCenteredGJcurPlot.m

close all

nonCon = find(numGaps == 0);
GJcon = find(numGaps == 15);

randSeedNC = randSeed(nonCon);
randSeedGJ = randSeed(GJcon);

upMix = unique(pMix);

% Remove randseeds that are not completed
uRandSeed = setdiff(randSeed, ...
                    setdiff(randSeed, ...
                         intersect(randSeedNC,randSeedGJ)));


cellCtr = ones(length(upMix),1);                     

clear refFreq GJfreq

for uIdx = 1:length(uRandSeed)
  refIdx = find(randSeed == uRandSeed(uIdx) & numGaps == 0);
  GJidx = find(randSeed == uRandSeed(uIdx) & numGaps == 15);
  
  if(isempty(setdiff(upMix, pMix(refIdx))) ...
      & isempty(setdiff(upMix, pMix(GJidx))))
    % All pMix values are in this run, use it.  

    for pIdx = 1:length(upMix)
      refPidx = refIdx(find(pMix(refIdx) == upMix(pIdx)));
      GJPidx = GJidx(find(pMix(GJidx) == upMix(pIdx)));
      
      for i=1:numCells(refPidx)
        c = cellCtr(pIdx);
        refFreq(pIdx,c) = firingFreq(refPidx,i);
        GJfreq(pIdx,c) = firingFreq(GJPidx,i);
        cellCtr(pIdx) = c + 1;
      end
    end
  end    
end


meanFreqRef = mean(refFreq,2);
meanFreqGJ = mean(GJfreq,2);
stdMeanFreqRef = std(refFreq,0,2) / sqrt(size(refFreq,2)-1);
stdMeanFreqGJ = std(GJfreq,0,2) / sqrt(size(GJfreq,2)-1);

p(1) = bar((1-upMix).^2,meanFreqRef,'r'); hold on
set(p(1),'facecolor',[144 144 254]/255)

p(2) = bar((1-upMix).^2,meanFreqGJ,0.65, 'k');
    
z = zeros(size(-stdMeanFreqGJ));

%errorbar(1-upMix,meanFreqRef,-stdMeanFreqRef,stdMeanFreqRef,'k.')
%errorbar(1-upMix,meanFreqGJ,-stdMeanFreqGJ,stdMeanFreqGJ, 'k.')
errorbar((1-upMix).^2,meanFreqRef,z,stdMeanFreqRef,'k.')
errorbar((1-upMix).^2,meanFreqGJ,z,stdMeanFreqGJ, 'k.')
    
legend(p,'Unconnected', ...
         'Gap junction','Location','Best');

xlabel('Proportion of shared input','FontSize',20)
ylabel('Frequency (Hz)','FontSize',20)
title('Gap junctions filter uncorrelated input','FontSize',24)
set(gca, 'xtick', (1 - upMix(end:-1:1)).^2)
set(gca, 'fontsize',20)
a = axis; a(1) = -0.2; a(2) = 1.2; axis(a)

box off

saveas(p(1), 'FIGS/TenFS/FS-freq-GJ-popCorrVar.fig', 'fig');
   
