% To run the simulation:
%
% runTenInhomoFSGJscanAllUpstateStandard.m
%
% Then read the data using:
%
% readTenFSAllupstateDataStandard.m
%
% This code assumes there are just two sets of configurations
% one with the 0.5nS GJ resistance, and one without any GJ (ref).
%

close all

%nBinsHist = 50;
%nBinsHist = 200
nBinsHist = 501

uNumGaps = unique(numGaps);

clear numDiffs numSCCC edges

for iGap = 1:length(uNumGaps)

  iGJ = find(uNumGaps(iGap) == numGaps);
    
  if(length(unique(gapResistance(iGJ))) > 1)
     disp('More than one GJ resistance used... not supported here')
     keyboard
  end
    
  combCtr = 1;
  
  for i = 1:length(iGJ)
    runIdx = iGJ(i);
      
    for cellA = 1:length(savedSpikeTimes{i})
      for cellB = (cellA + 1):length(savedSpikeTimes{i})
   
        [numSCCC{iGap}(:,combCtr), ...
         numDiffs{iGap}(:,combCtr), ...
         edges{iGap}(:,combCtr)] = ... 
            makeSCCCplot(savedSpikeTimes, runIdx, cellA, ...
                         savedSpikeTimes, runIdx, cellB, ...
                         maxTime(runIdx), nBinsHist, 0);
                     
                  
         % MODIFIKATION: Dela med maxtiden för att få frekvens
         numDiffs{iGap}(:,combCtr) = numDiffs{iGap}(:,combCtr) ...
                                   / maxTime(runIdx);

         combCtr = combCtr + 1;
         
 
      end     
    end    
  end           
end

for i=1:length(numDiffs)
  meanCC{i} = mean(numDiffs{i},2);
  stdErrCC{i} = std(numDiffs{i},0,2)/sqrt(size(numDiffs{i},2)-1);
    
end

ccEdges = edges{i}(:,1);

% Plotta

figure, clf 

clear pHand

for i=1:length(numDiffs)
  
  pHand(i) = subplot(length(numDiffs),1,length(numDiffs)-i+1);
  bar(ccEdges, meanCC{i},'histc')

  xlabel('Time (s)')
  % ylabel('Frequency (Hz)')
  ylabel('Occurances (s^{-1})')
  
  if(uNumGaps(i) > 0)
    title('Gap junction coupled')
  else
    title('Uncoupled')
  end
  
  a = axis;
  a(1) = min(ccEdges); a(2) = max(ccEdges);
  axis(a);
  
end

linkprop(pHand,'Ylim');


saveas(pHand(1), ['FIGS/TenFS-allUpstateStandard-RAWcc.fig'], 'fig')

%%%%%%%%%%%%

figure

clear pHand pLeg

for i=1:length(numDiffs)
  
  pHand(i) = bar(1e3*ccEdges, meanCC{i},'histc'), hold on

  if(uNumGaps(i) > 0)
    pLeg{i} = 'Gap junction coupled';
  else
    pLeg{i} = 'Uncoupled';
  end
  
  a = axis;
  %a(1) = min(1e3*ccEdges); a(2) = max(1e3*ccEdges);
  a(1) = -100; a(2) = 100;
  a(1) = -50; a(2) = 50;
  axis(a);

  
  
end

box off

xlabel('Time (ms)')
%ylabel('Frequency (Hz)')
ylabel('Occurances (s^{-1})')
  
saveas(pHand(1), ['FIGS/TenFS-allUpstateStandard-RAWcc-AllInOneFINER.fig'], 'fig')
