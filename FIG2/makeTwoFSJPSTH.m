% 1. readTenFSGJscanDataSquare  
% 2. makeTenFS3dGJscanPlots
% 3. makeTenFSJPSTH

close all

clear JPSTH

uNumGaps = unique(numGaps);

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

    % Gör en check som kollar alla kombos

    % combCtr = 1;
    
    Jflag = 0;
    
    for i=1:nCells
      for j=(i+1):nCells
        
        cellIdx1 = i;
        cellIdx2 = j;

        for k=1:length(runIdx1)
          a = makeJPST(savedSpikeTimes{runIdx1(k)}{cellIdx1}, ...
                         savedSpikeTimes{runIdx2(k)}{cellIdx2}, ...
                         maxTime(1));

          if(Jflag)
            JPSTH{iGap}{iRes} = JPSTH{iGap}{iRes} + a;
          else
            JPSTH{iGap}{iRes} = a;
            Jflag = 1;
          end
                     
          % combCtr = combCtr + 1;
        end
      end
    end
  end
end


for i=1:length(JPSTH)
  for iRes = 1:length(uGJres{i})  
    p = figure;
    spy(JPSTH{i}{iRes}(end:-1:1,:));
    title(['All FS, num Gaps: ' num2str(uNumGaps(i)) ...
           ' GJcond ' num2str(1/uGJres{i}(iRes))])
   
    saveas(p, ['FIGS/AllFScon-numGaps-' num2str(uNumGaps(i)) ...
               '-GJcond' num2str(1/uGJres{i}(iRes)) '.fig'], 'fig')
  end
end



%%% Do same but only with connected cells this time


clear JPSTHneigh

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

    % Gör en check som kollar alla kombos

    % combCtr = 1;
    
    Jflag = 0;
    
    
    for i=1:length(iGJres)
      for j=1:max(conMat{iGJres(i)}(:))
        [x,y] = find(conMat{iGJres(i)} == j);

        runIdx1 = iGJres(i);
        runIdx2 = iGJres(i);

        cellIdx1 = x(1);
        cellIdx2 = y(1);

        for k=1:length(runIdx1)
          a = makeJPST(savedSpikeTimes{runIdx1(k)}{cellIdx1}, ...
                         savedSpikeTimes{runIdx2(k)}{cellIdx2}, ...
                         maxTime(1));

          if(Jflag)
            JPSTHneigh{iGap}{iRes} = JPSTHneigh{iGap}{iRes} + a;
          else
            JPSTHneigh{iGap}{iRes} = a;
            Jflag = 1;
          end
                     
          % combCtr = combCtr + 1;
        end
      end
    end
  end
end

for i=1:length(JPSTHneigh)
  for iRes = 1:length(uGJres{i})  
    p = figure;
    spy(JPSTHneigh{i}{iRes}(end:-1:1,:));
    title(['Only connected FS, num Gaps: ' num2str(uNumGaps(i)) ...
           ' GJcond ' num2str(1/uGJres{i}(iRes))])

    saveas(p, ['FIGS/NeighFScon-numGaps-' num2str(uNumGaps(i)) ...
               '-GJcond' num2str(1/uGJres{i}(iRes)) '.fig'], 'fig')
  end
end



%%%%%%%%%%%%%%%%%%%%%
%
% Show the height of the bins also


if(0)

  for i=1:length(JPSTH)
    for iRes = 1:length(uGJres{i})  
      figure    
      surf(full(JPSTH{i}{iRes}))
      title(['All FS, num Gaps: ' num2str(uNumGaps(i)) ...
             ' GJcond ' num2str(1/uGJres{i}(iRes))])
    end
  end

  for i=1:length(JPSTHneigh)
    for iRes = 1:length(uGJres{i})  
      figure    
      surf(full(JPSTHneigh{i}{iRes}))
      title(['Only connected FS, num Gaps: ' num2str(uNumGaps(i)) ...
             ' GJcond ' num2str(1/uGJres{i}(iRes))])
    end
  end
end


if(0)
  % Histogram over # spikes in a bin, CODE NOT DONE
  clear SPhist

  for i=1:length(JPSTH)
    for j = 1:length(JPSTH{i})
      figure    
      
      for k = 1:full(max(max(JPSTH{i}{j})))
        % First index number of GJ
        % Second index GJ resistance
        % Third index is number of bins with k spikes in it
        SPhist{i}(j,k) = length(find(JPSTH{i}{j}==k));
      end     
          
      title(['All FS, num Gaps: ' num2str(uNumGaps(i)) ...
             ' GJcond ' num2str(1/uGJres{i}(iRes))])
    end
  end

end
