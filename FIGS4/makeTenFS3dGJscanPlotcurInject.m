%
% For supplementary material figure S4A
%
% Cur inject -- freq figure
% /home/hjorth/genesis/fsCurInputInhomogeneNetwork
%
%
% runTenFScurInejctInhomogeneNetworkGJscan.m
% readTenFSGJscanInjectCur.m
% makeTenFS3dGJscanPlotcurInject.m
%
% or
%
% makeTenFSGJscanPlotCurInject
close all

if(~exist('filteredFirst50MS'))
  filteredFirst50MS = 1;
  disp('Filtering out the first 50 ms of the run')
  disp('There is an initial spike when current injection starts')
  
  for i=1:length(savedSpikeTimes)
    for j=1:length(savedSpikeTimes{i})
      k = find(savedSpikeTimes{i}{j} < 50e-3);
      savedSpikeTimes{i}{j}(k) = [];
    end
    maxTime(i) = maxTime(i) - 50e-3;
  end
end

disp('This code handles plots even if there are no spikes for some cells')
disp('makeTenFS3dGJscanPlot.m doesnt do that')

% If we want to exclude datapoints that have too high GJ conductance
% filterStart = 3;
filterStart = 1;
az = 106.5; el = 6;

clear pHand, pHand = [];

clear saveHandle saveFileName

%clear all, close all

% readTenFSGJscanDataSquare
%
% Although we should probably use all upstate data for these graphs,
% to avoid unneccessary bias...
%
% readTenFSGJscanAllUpstate

%%%%% First lets make 2D conductance vs spike freq plots

uNumGaps = unique(numGaps);

for i=1:length(savedSpikeTimes)
  for j=1:length(savedSpikeTimes{1})
    outFreq(i,j) = length(savedSpikeTimes{i}{j})/maxTime(i);      
  end
end



for iGap = 1:length(uNumGaps)
  % Hitta all data som har rätt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uGJres{iGap} = unique(gapResistance(iMask));

  for iRes = 1:length(uGJres{iGap})
    % Gå igenom varje resistans som finns för aktuella antal GJ
    iGJres = iMask(find(gapResistance(iMask) == uGJres{iGap}(iRes)));
    
    allFreq = outFreq(iGJres,:);
    meanFSfreq{iGap}(iRes) = mean(allFreq(:));
    stdFSfreq{iGap}(iRes) = std(allFreq(:));
    stdmFSfreq{iGap}(iRes) = std(allFreq(:))/sqrt(length(allFreq(:))-1);
  end
end

figure(1), clf

p = plot(1./[max(uGJres{2}) min(uGJres{2})], repmat(meanFSfreq{1},2,1), ...
         1./uGJres{2}, meanFSfreq{2}); hold on

errorbar(mean(1./[max(uGJres{2}) min(uGJres{2})]), ...
         meanFSfreq{1}, -stdFSfreq{1}, stdFSfreq{1}, '*k')
errorbar(1./uGJres{2}, meanFSfreq{2}, -stdFSfreq{2}, stdFSfreq{2}, '*k')

xlabel('Conductance (S)')
ylabel('Spike frequency')

legend(p, ['Num GJ : ' num2str(uNumGaps(1))], ...
          ['Num GJ : ' num2str(uNumGaps(2))])

saveHandle{1} = gcf;
saveFileName{1} = 'FIGS/TenFS/freqSpikes-STD-curinject.fig';
%saveas(gcf, 'FIGS/TenFS/freqSpikes-STD.fig', 'fig')
   
      
figure(2), clf

% p = plot(1./[uGJres{2}(2) uGJres{2}(end)], repmat(meanFSfreq{1},2,1), ...
%          1./uGJres{2}(2:end), meanFSfreq{2}(2:end)); hold on

p = plot([1e9./uGJres{2}(1:end) 0], [meanFSfreq{2}(1:end) meanFSfreq{1} ]);
     hold on
     
     
errorbar([1e9./uGJres{2}(1:end) 0], ...
         [meanFSfreq{2}(1:end) meanFSfreq{1} ], ...
         [-stdmFSfreq{2}(1:end) -stdmFSfreq{1}], ...
         [ stdmFSfreq{2}(1:end) stdmFSfreq{1}], '*k')

a = axis;
a(1) = 0;
a(2) = 1e9./uGJres{2}(1);
a(3) = 0;
axis(a)
     
xlabel('Conductance (nS)','fontsize',24)
ylabel('Spike frequency (Hz)', 'fontsize',24)
set(gca,'fontsize',24)

saveHandle{2} = gcf;
saveFileName{2} = 'FIGS/TenFS/freqSpikes-STDerr-curinject.fig';
      

%%%%% Lets make conductance vs DCC correlation plot

%% LETS DO THAT TOMORROW, ALMOST MIDNIGHT



figNum = 0;
nCells = numCells(1);
%nBinsHist = 200;
nBinsHist = 50;

clear numSCCC numDiffs edges


for iGap = 1:length(uNumGaps)
  % Hitta all data som har rätt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uGJres{iGap} = unique(gapResistance(iMask));

  
  for iRes = 1:length(uGJres{iGap})
    % Gå igenom varje resistans som finns för aktuella antal GJ
    iGJres = iMask(find(gapResistance(iMask) == uGJres{iGap}(iRes)));
    
    %runIdx1 = iGJres;
    %runIdx2 = iGJres;
    
    nCells = numCells(iGJres(1));

    % Gör en check som kollar alla kombos

    combCtr = 1;
    
    for k=1:length(iGJres)
      runIdx1 = iGJres(k);
      runIdx2 = iGJres(k);
        
      for i=1:nCells
        for j=(i+1):nCells
        
          cellIdx1 = i;
          cellIdx2 = j;

          runIdx1T = runIdx1;
          runIdx2T = runIdx2;
          
          for m=length(runIdx1):-1:1
            if(length(savedSpikeTimes{runIdx1T(m)}{cellIdx1}) < 1)
              runIdx1T(m) = [];
              disp('Removing non-spiking cell from cross correlogram')
            end
          end

          for m=length(runIdx2):-1:1
            if(length(savedSpikeTimes{runIdx2T(m)}{cellIdx2}) < 1)
              runIdx2T(m) = [];
              disp('Removing non-spiking cell from cross correlogram')
            end
          end         

          % This code assumes that the cell spikes in atleast one of
          % the runs
          
          if(isempty(runIdx1T) || isempty(runIdx2T))
            numSCCC{iGap}(:,iRes,combCtr) = zeros(nBinsHist,1);
            numDiffs{iGap}(:,iRes,combCtr) = zeros(nBinsHist,1);
            edges{iGap}(:,iRes,combCtr) = linspace(-0.25,0.25,nBinsHist);
          else
          
            [numSCCC{iGap}(:,iRes,combCtr), ...
             numDiffs{iGap}(:,iRes,combCtr), ... 
             edges{iGap}(:,iRes,combCtr)] = ...
                       makeSCCCplot(savedSpikeTimes, runIdx1T, cellIdx1, ...
                                    savedSpikeTimes, runIdx2T, cellIdx2, ...
                                    maxTime(1), nBinsHist, figNum);
          end
          combCtr = combCtr + 1;
        end
      end
    end
  end
end

% Plot the DCC 3d plot for all combinations of neurons
%
%
% uNumGaps(1) bör vara 0, det är referenskörningen.

for iGap = 2:length(uNumGaps)

  idxGap = find(numGaps == uNumGaps(iGap));
  idxRef = find(numGaps == 0);
  
  uRandSeed = unique(conMatRandSeed(idxGap));

  for iRand = 1:length(uRandSeed)
    
    % Hitta körningarna och referensekörningarna  
    idxRand = idxGap(find(conMatRandSeed(idxGap) == uRandSeed(iRand)));
    idxRandRef = idxRef(find(conMatRandSeed(idxRef) == uRandSeed(iRand)));
    
    if(length(idxRandRef) ~= 1)
      disp('make3dGJscanPlots.m - More than one reference run, weird!') 
      keyboard
    end
  
    % Dra bort referenskörningarna från körningarna
    [xc,yc,zc] = size(numDiffs{iGap});
    
    CC3D{iGap}(:,:,iRand) = mean(numDiffs{iGap},3) ...
                          - repmat(mean(numDiffs{1},3),1,yc);        
    
  end

  mCC3D{iGap} = mean(CC3D{iGap},3);


  % Add the non-connected case, ie GJ cond = 0
  [grid3Dx{iGap},grid3Dy{iGap}] = meshgrid([1./uGJres{iGap} 0], ...
                                           edges{1}(:,1,1));

  
  figure,clf,pHand=[pHand subplot(1,1,1)];

 
  % Reason for 1:end-1 in first argument is that the histc has each
  % bin containing edges(k) <= edges(k+1), but the last bin which is
  % just values x = edges(end), removing that one.  
  
  disp('Filtering data, removing datapoint')

  pDCCALL = surf(grid3Dx{iGap}(1:end-1,filterStart:end), ...
                 grid3Dy{iGap}(1:end-1,filterStart:end), ...
                 [mCC3D{iGap}(1:end-1,filterStart:end)/maxTime(1) ...
                 zeros(nBinsHist-1,1)]);

  alpha(0.5)
  view(az,el)
  a = axis; a(3) = -0.25; a(4) = 0.25; axis(a)
  
  saveHandle{end+1} = pDCCALL;
  saveFileName{end+1} = ['FIGS/TenFS/3d-DCC-GJ-' num2str(uNumGaps(iGap)) '-curinject.fig'];
  
  % Bör lägga till kod som kompenserar för färre spikar också
  % dock för ny figur, behåll denna... intressant. 
  % Tar man filterStart = 2 ser man ökat antal spikar som
  % synkroniserar. Undra vad som händer i detta intervallet om vi
  % lägger på dopamine... TESTA
  
end



    
    % Gör en check som kollar bara direkta grannar

clear numSCCCneigh numDiffsneigh edgesneigh
    
    
 for iGap = 1:length(uNumGaps)
  % Hitta all data som har rätt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uGJres{iGap} = unique(gapResistance(iMask));

  
  for iRes = 1:length(uGJres{iGap})
    % Gå igenom varje resistans som finns för aktuella antal GJ
    iGJres = iMask(find(gapResistance(iMask) == uGJres{iGap}(iRes)));
    
    runIdx1 = iGJres;
    runIdx2 = iGJres;
    
    nCells = numCells(iGJres(1));   
    
    combCtr = 1;
    
    for i=1:length(iGJres)
      for j=1:max(conMat{iGJres(i)}(:))
        [x,y] = find(conMat{iGJres(i)} == j);

        runIdx1 = iGJres(i);
        runIdx2 = iGJres(i);
        
        cellIdx1 = x(1);
        cellIdx2 = y(1);

        if(length(savedSpikeTimes{runIdx1}{cellIdx1}) < 1 ...
           || length(savedSpikeTimes{runIdx2}{cellIdx2}) < 1)

           numSCCCneigh{iGap}(:,iRes,combCtr) = zeros(nBinsHist,1);
           numDiffsneigh{iGap}(:,iRes,combCtr) = zeros(nBinsHist,1);
           edgesneigh{iGap}(:,iRes,combCtr) = linspace(-0.25,0.25,nBinsHist);

        else
           
        [numSCCCneigh{iGap}(:,iRes,combCtr), ...
         numDiffsneigh{iGap}(:,iRes,combCtr), ...
         edgesneigh{iGap}(:,iRes,combCtr)] = ...
                 makeSCCCplot(savedSpikeTimes, runIdx1, cellIdx1, ...
                              savedSpikeTimes, runIdx2, cellIdx2, ...
                              maxTime(1), nBinsHist, figNum);
        end

                          
        combCtr = combCtr + 1;
        
      end
    end
    
  end
end


% Plot the DCC 3d plot only for direct neighbours
%
%


for iGap = 2:length(uNumGaps)

  idxGap = find(numGaps == uNumGaps(iGap));
  idxRef = find(numGaps == 0);
  
  uRandSeed = unique(conMatRandSeed(idxGap));

  for iRand = 1:length(uRandSeed)
    
    % Hitta körningarna och referensekörningarna  
    idxRand = idxGap(find(conMatRandSeed(idxGap) == uRandSeed(iRand)));
    idxRandRef = idxRef(find(conMatRandSeed(idxRef) == uRandSeed(iRand)));
    
    if(length(idxRandRef) ~= 1)
      disp('make3dGJscanPlots.m - More than one reference run, weird!') 
      keyboard
    end
  
    % Dra bort referenskörningarna från körningarna
    [xc,yc,zc] = size(numDiffsneigh{iGap});
    
    CC3Dneigh{iGap}(:,:,iRand) = mean(numDiffsneigh{iGap},3) ...
                               - repmat(mean(numDiffsneigh{1},3),1,yc);        
    
  end

  mCC3Dneigh{iGap} = mean(CC3Dneigh{iGap},3);

  [grid3Dx{iGap},grid3Dy{iGap}] = meshgrid([1./uGJres{iGap} 0 ], ...
                                           edgesneigh{1}(:,1,1));

  figure,clf,pHand=[pHand subplot(1,1,1)];

  
  disp('Filtering data, removing datapoint')
  
  % Reason for 1:end-1 in first argument is that the histc has each
  % bin containing edges(k) <= edges(k+1), but the last bin which is
  % just values x = edges(end), removing that one.
  
  pDCCNEIGH = surf(grid3Dx{iGap}(1:end-1,filterStart:end), ...
                   grid3Dy{iGap}(1:end-1,filterStart:end), ...
                   [mCC3Dneigh{iGap}(1:end-1,filterStart:end)/maxTime(1) ...
                     zeros(nBinsHist-1,1)]);
  alpha(0.5)
  
  view(az,el)
  a = axis; a(3) = -0.25; a(4) = 0.25; axis(a)
  
  
  saveHandle{end+1} = pDCCNEIGH;
  saveFileName{end+1} = ['FIGS/TenFS/3d-DCC-ONLYNEIGHBOURS-GJ' num2str(uNumGaps(iGap)) '.fig'];
 
  
  % Bör lägga till kod som kompenserar för färre spikar också
  % dock för ny figur, behåll denna... intressant. 
  % Tar man filterStart = 2 ser man ökat antal spikar som
  % synkroniserar. Undra vad som händer i detta intervallet om vi
  % lägger på dopamine... TESTA
  
end


% Now we need to do the same for all neurons that are not direct neighbours
%
%



clear numSCCCnonNeigh numDiffsnonNeigh edgesnonNeigh
    
    
 for iGap = 1:length(uNumGaps)
  % Hitta all data som har rätt antal GJ
  iMask = find(numGaps == uNumGaps(iGap));
  
  uGJres{iGap} = unique(gapResistance(iMask));

  
  for iRes = 1:length(uGJres{iGap})
    % Gå igenom varje resistans som finns för aktuella antal GJ
    iGJres = iMask(find(gapResistance(iMask) == uGJres{iGap}(iRes)));
    
    runIdx1 = iGJres;
    runIdx2 = iGJres;
    
    nCells = numCells(iGJres(1));   
    
    combCtr = 1;
    
    for i=1:length(iGJres)
        
      [x,y] = find(conMat{iGJres(i)} == 0);

      % Just take half the matrix, and not self connections
      xidx = find(x < y);

      for j=1:length(xidx)
          
        cellIdx1 = x(xidx(j));
        cellIdx2 = y(xidx(j));
        
        runIdx1 = iGJres(i);
        runIdx2 = iGJres(i);
        
        if(length(savedSpikeTimes{runIdx1}{cellIdx1}) < 1 ...
           || length(savedSpikeTimes{runIdx2}{cellIdx2}) < 1)

          numSCCCnonNeigh{iGap}(:,iRes,combCtr) = zeros(nBinsHist,1);
          numDiffsnonNeigh{iGap}(:,iRes,combCtr) = zeros(nBinsHist,1);
          edgesnonNeigh{iGap}(:,iRes,combCtr) = linspace(-0.25,0.25,nBinsHist);

        else        
        
          [numSCCCnonNeigh{iGap}(:,iRes,combCtr), ...
           numDiffsnonNeigh{iGap}(:,iRes,combCtr), ...
           edgesnonNeigh{iGap}(:,iRes,combCtr)] = ...
                   makeSCCCplot(savedSpikeTimes, runIdx1, cellIdx1, ...
                                savedSpikeTimes, runIdx2, cellIdx2, ...
                                maxTime(1), nBinsHist, figNum);
        end
                            
        combCtr = combCtr + 1;
        
      end
    end
    
  end
end


% Plot the DCC 3d plot only for non-direct neighbours
%
%


for iGap = 2:length(uNumGaps)

  idxGap = find(numGaps == uNumGaps(iGap));
  idxRef = find(numGaps == 0);
  
  uRandSeed = unique(conMatRandSeed(idxGap));

  for iRand = 1:length(uRandSeed)
    
    % Hitta körningarna och referensekörningarna  
    idxRand = idxGap(find(conMatRandSeed(idxGap) == uRandSeed(iRand)));
    idxRandRef = idxRef(find(conMatRandSeed(idxRef) == uRandSeed(iRand)));
    
    if(length(idxRandRef) ~= 1)
      disp('make3dGJscanPlots.m - More than one reference run, weird!') 
      keyboard
    end
  
    % Dra bort referenskörningarna från körningarna
    [xc,yc,zc] = size(numDiffsnonNeigh{iGap});
    
    CC3DnonNeigh{iGap}(:,:,iRand) = mean(numDiffsnonNeigh{iGap},3) ...
                               - repmat(mean(numDiffsnonNeigh{1},3),1,yc);        
    
  end

  mCC3DnonNeigh{iGap} = mean(CC3DnonNeigh{iGap},3);

%  [grid3Dx{iGap},grid3Dy{iGap}] = meshgrid(1./uGJres{iGap},edgesnonNeigh{1}(:,1,1));

  % Add the non-connected case
  [grid3Dx{iGap},grid3Dy{iGap}] = meshgrid([1./uGJres{iGap} 0],edgesnonNeigh{1}(:,1,1));

  figure,clf,pHand=[pHand subplot(1,1,1)];

  
  disp('Filtering data, removing datapoint')
  
  % Reason for 1:end-1 in first argument is that the histc has each
  % bin containing edges(k) <= edges(k+1), but the last bin which is
  % just values x = edges(end), removing that one.
  
  pDCCNONNEIGH = surf(grid3Dx{iGap}(1:end-1,filterStart:end), ...
                      grid3Dy{iGap}(1:end-1,filterStart:end), ...
                      [mCC3DnonNeigh{iGap}(1:end-1,filterStart:end)/maxTime(1) ...
                        zeros(nBinsHist-1,1)]);
  alpha(0.5)
  view(az,el)
  a = axis; a(3) = -0.25; a(4) = 0.25; axis(a)
  
  saveHandle{end+1} = pDCCNONNEIGH;
  saveFileName{end+1} = ['FIGS/TenFS/3d-DCC-NOT-NEIGHBOURS-GJ' num2str(uNumGaps(iGap)) '-curinject.fig'];


  % Bör lägga till kod som kompenserar för färre spikar också
  % dock för ny figur, behåll denna... intressant. 
  % Tar man filterStart = 2 ser man ökat antal spikar som
  % synkroniserar. Undra vad som händer i detta intervallet om vi
  % lägger på dopamine... TESTA
  
end

% Make sure all graphs have same view and axis... :)
linkprop(pHand,'View');
linkprop(pHand,'Xlim');
linkprop(pHand,'Ylim');
if(length(pHand) ~= 3)
  linkprop(pHand,'Zlim');
else
  linkprop(pHand([2,1,3]),'Zlim');
end



for i=1:length(saveHandle)
  saveas(saveHandle{i},saveFileName{i},'fig') 
end
