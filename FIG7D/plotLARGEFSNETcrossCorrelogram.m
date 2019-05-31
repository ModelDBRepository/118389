%
% To generate figure 7D, run the following MATLAB scripts
%
% runLARGEAllUpstateOnlyPrimWrappedNGJscan.m
% runLARGEAllUpstateOnlySecWrappedNGJscan.m
%
% readLARGEnetOnlyPrimWrappedNGJ.m
% plotLARGEFSNETcrossCorrelogram.m
%
% readLARGEnetOnlySecWrappedNGJ.m
% plotLARGEFSNETcrossCorrelogram.m
%
% plotLARGEFSNETcrossCorrelogramMERGEDupdatedFig7D.m
%
%
% This code assumes there are just two sets of configurations
% one with the 0.5nS GJ resistance, and one without any GJ (ref).
%

close all

nBinsHist = 501

uNumGaps = unique(numGaps);

clear numDiffs numSCCC edges



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%First we need to recover the connection matrix
%



for fileCtr = 1:length(savedSpikeTimes)

  if(numGaps(fileCtr) == 0)
    % No gap junctions
    for cellCtr = 1:length(savedSpikeTimes{fileCtr})
       selfSpikes{fileCtr}(cellCtr) = length(savedSpikeTimes{fileCtr}{cellCtr});
       spikeTrig{fileCtr}(cellCtr) = 0;
    end

    continue;
  end

  coMat{fileCtr} = zeros([1 1]*length(savedSpikeTimes{fileCtr}));

  % Reconstruct the connection matrix cMat
  for gapCtr = 1:numGaps(fileCtr)
    srcIdx = textscan(gapSource{fileCtr}{gapCtr}{1},'/fs[%d]');
    destIdx = textscan(gapDest{fileCtr}{gapCtr}{1},'/fs[%d]');

    % +1 since matlab indexing starts from 1, not 0
    coMat{fileCtr}(srcIdx{1}+1,destIdx{1}+1) = ...
         coMat{fileCtr}(srcIdx{1}+1,destIdx{1}+1) + 1;

    %keyboard
  end

  % Each GJ only appears ones in the connection matrix
  
  % This code makes it appear twice, dont use it for cross correlogram
  % coMat{fileCtr} = coMat{fileCtr} + coMat{fileCtr}';
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for iGap = 1:length(uNumGaps)

  disp(sprintf('Processing %d gap junctions..',uNumGaps(iGap)))
    
  iGJ = find(numGaps == uNumGaps(iGap));
    
  if(length(unique(gapResistance(iGJ))) > 1)
     disp('More than one GJ resistance used... not supported here')
     keyboard
  end
    
  % Only calculate the cross correlogram between connected neighbours
  % except for the case when there is no gap junctions, then we use
  % all neighbours.

  combCtr = 1;  
  
  if(uNumGaps(iGap) == 0)
    for i=1:length(iGJ);
       runIdx = iGJ(i);
       
       %for cellA = 1:length(savedSpikeTimes{runIdx})
         %for cellB = (cellA + 1):length(savedSpikeTimes{runIdx})
         % We run a subproportion of the combinations
       
       for cellA = 1:length(savedSpikeTimes{runIdx})
         %disp(sprintf('CellA = %d',cellA))
         randPB = randperm(length(savedSpikeTimes{runIdx}));
         
         for cellB = randPB(1:10)

           if(cellA == cellB)
             % Dont match it against itself
             continue
           end
             
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
      
    continue 
  end
  
  %%%%%%%%%%%%%%
  
  
  for i = 1:length(iGJ)
    runIdx = iGJ(i);
    
    % We need to number the gap junction connections
    cMat = double(coMat{runIdx});
    cMat(find(cMat)) = 1:length(find(cMat));
    
    for j=1:max(cMat(:))
        
      [x,y] = find(cMat == j);
      cellA = x(1);
      cellB = y(1);
 
   
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


saveas(pHand(1), ['FIGS/LARGE-allUpstateStandard-RAWcc-onlyConNeigh.fig'], 'fig')

%%%%%%%%%%%%

figure

clear pHand pLeg

cm = colormap;
lineCol = interp1(linspace(0,1,size(cm,1)),cm,linspace(0,1,length(numDiffs)));

for i=1:length(numDiffs)
  
%  pHand(i) = bar(1e3*ccEdges, meanCC{i},'histc'), hold on
  pHand(i) = stairs(1e3*ccEdges, meanCC{i}, 'color',lineCol(i,:)); hold on

  if(uNumGaps(i) > 0)
    pLeg{i} = sprintf('%d gap junctions', uNumGaps(i)*2/numCells(1));
  else
    pLeg{i} = 'Uncoupled';
  end
  
  
end

nGJ = uNumGaps*2/numCells(1);

a = axis;
a(1) = -50; a(2) = 50;
axis(a);

legend(pHand,pLeg)

box off

xlabel('Time (ms)')
%ylabel('Frequency (Hz)')
ylabel('Occurances (s^{-1})')
  
saveas(pHand(1), ['FIGS/LARGE-allUpstateStandard-RAWcc-AllInOneFINER-onlyConNeigh.fig'], 'fig')


curPath = pwd;
cd(filePath)
save crossCorrData.mat nGJ ccEdges meanCC
cd(curPath)
