% First read the data using:
%
% readTenFSAllupstateDataStandard.m
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
    
  % In the size 10 version, we select a center neuron, then the six
  % neighbours directly adjacent, then we randomly select three out of
  % the remaining 20 that are within a 3x3x3 cube.

  combCtr = 1;  

  nCells = length(savedSpikeTimes{1});
  
  if(nCells ~= 125)
    disp('This code only supports 125 neurons.')
    keyboard
  end

  % Here we assume 5x5x5 FS
  
  [X,Y,Z] = meshgrid(0:4,0:4,0:4);

  Aneigh = [1 0 0; 0 1 0; 0 0 1; -1 0 0; 0 -1 0; 0 0 -1];
  ANall = [];
  
  for x=-1:1
    for y=-1:1
      for z = -1:1
         ANall = [ANall; x y z];
      end
    end
  end

  ANrest = setdiff(ANall,Aneigh,'rows');
  
  % We must remove centre neuron, since it is cellA already.
  ANrest = setdiff(ANrest, [0 0 0], 'rows'); 
  
  for i=1:length(iGJ)
    runIdx = iGJ(i);

      
    for cellA = 1:length(savedSpikeTimes{runIdx})
  
      Ax = X(cellA); Ay = Y(cellA); Az = Z(cellA);
      
      randNeighB = randperm(length(ANrest));
      randNeighB = randNeighB(1:3);
      % We use 1 + 6 + 3 neurons total, centre + neigh + rand
      % Centre is already neuron 1, so rNeighX is 6 + 3 neurons
      rNeighX = [Aneigh(:,1); ANrest(randNeighB,1)]; 
      rNeighY = [Aneigh(:,2); ANrest(randNeighB,2)];
      rNeighZ = [Aneigh(:,3); ANrest(randNeighB,3)];
      
      for j=1:length(rNeighX)
        cellB = find(mod(Ax + rNeighX(j),5) == X & ...
                     mod(Ay + rNeighY(j),5) == Y & ...
                     mod(Az + rNeighZ(j),5) == Z);      
        
        if(cellA == cellB)
          disp('Internal error, cellA = cellB')
          keyboard
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


saveas(pHand(1), ['FIGS/LARGE-allUpstateStandard-RAWcc-size10.fig'], 'fig')

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
  
saveas(pHand(1), ['FIGS/LARGE-allUpstateStandard-RAWcc-AllInOneFINER-size10.fig'], 'fig')


curPath = pwd;
cd(filePath)
save crossCorrDataSize10.mat nGJ ccEdges meanCC
cd(curPath)
