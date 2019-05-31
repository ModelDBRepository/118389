%
% This code reads in the TenFS sensitivity simulation output and tries
% to extract the interresting differences and present it.
%
% 1. Average spike frequency, and standard error of the mean
% 2. Spike centered gap junction current
% 3. Cross-correlogram
% 4. Number of spikes within 1ms, 5ms, 10ms of each other.
%

clear all, close all

filesData = dir(['UTDATA/TenFS*.data']);

RGJ = 2e9;


tPre  = -10e-3; tPost =  10e-3; 

tRange = linspace(-50e-3,50e-3,20);

parType = {'g_{Na}', 'g_{KA}', 'g_{Kv3.1/3.2}', 'g_{Kv1.3}', ...
           '\tau_m (Na)', '\tau_h (Na)', '\tau_m (KA)', '\tau_h (KA)', ...
           '\tau_{Kv3.1/3.2}','\tau_{Kv1.3}'};
           
for fCtr = 1:length(filesData)
  disp(sprintf('Reading %s', filesData(fCtr).name))

  data = load(sprintf('UTDATA/%s', filesData(fCtr).name));

  tmp = regexp(filesData(fCtr).name,'ID[0-9]+','match');
  randId(fCtr) = str2num(tmp{1}(3:end));

  % Only load connection matrix if we really need to use it
  if(fCtr == 1 | randId(fCtr-1) ~= randId(fCtr))
    conMat = ...
      load(sprintf('INDATA/connectionMatrix-ID%d.mat', randId(fCtr)));
  end

  tmp = regexp(filesData(fCtr).name,'freq-[.0-9]+Hz','match');
  inFreq(fCtr) = str2num(tmp{1}(6:end-2));
  
  infoFile = sprintf('INDATA/%s',strrep(filesData(fCtr).name,'.data','.info'));
  
  fid = fopen(infoFile,'r');
  
  dataFileName   = fgetl(fid);
  maxTime(fCtr)  = strread(fgetl(fid), '%f');
  numCells(fCtr) = strread(fgetl(fid), '%d');
  tmp            = fgetl(fid);
  FSpars(fCtr,:) = strread(tmp, '%f','delimiter',' ');
  numGJ(fCtr)    = strread(fgetl(fid), '%d');
  
  parIdx = find(FSpars(fCtr,:)-1);
  if(length(parIdx) > 1)
    pLeg{fCtr} = 'More than one modified';
    parChanged(fCtr) = NaN;
    
  elseif(isempty(parIdx))
    pLeg{fCtr} = 'Reference';  
    parChanged(fCtr) = 0;
  else
    pLeg{fCtr} = [sprintf('%s %.0f', parType{parIdx}, ...
                            (FSpars(fCtr,parIdx)-1)*100) '%' ];
    parChanged(fCtr) = parIdx;
              
  end  
  
  
  for i=1:(numCells(fCtr)/2)
    gapsOnCell{i} = []; 
  end
  
  for i=1:numGJ(fCtr)
    [tmpSrc tmpDest gapRes(fCtr,i)] = strread(fgetl(fid), '%s %s %f');

    tmp = regexp(tmpSrc,'/fs\[[0-9]+\]','match');
    gapSrc(fCtr,i) = str2num(tmp{1}{1}(5:end-1));

    gapsOnCell{gapSrc(fCtr,i)/2 + 1}(end+1) = i;
    
    tmp = regexp(tmpDest,'/fs\[[0-9]+\]','match');
    gapDest(fCtr,i) = str2num(tmp{1}{1}(5:end-1));

    gapsOnCell{gapDest(fCtr,i)/2 + 1}(end+1) = -i;
    
  end

  
  if(numGJ(fCtr) == 0)
    gapResistance(fCtr) = inf;
  else
    if(checkAllEqual(gapRes(fCtr,:)))
      gapResistance(fCtr) = gapRes(fCtr,1);
    else
      disp('analyseData: All gap resistances are not equal!')
      keyboard
    end
  end

  fclose(fid);

  time = data(:,1);
  
  if(~exist('idxRange'))
    idxRange = find(0.5 + tPre <= time & time <= 0.5 + tPost) ...
                 - find(time == 0.5);
    dataLen = length(idxRange);
  end
  
  voltGJ = data(:,2:2:(numCells(fCtr)+1));
  voltRef = data(:,3:2:(numCells(fCtr)+1));
  voltPrim1 = data(:,(numCells(fCtr)+1)+(1:2:(2*numGJ(fCtr))));
  voltPrim2 = data(:,(numCells(fCtr)+1)+(2:2:(2*numGJ(fCtr))));
  GJcur = (voltPrim1 - voltPrim2)/RGJ;

           
  %%%%%%%%%%%%%%
  %%
  %% Calculate ISI and spike frequency
  %%
  
  spikesGJ{fCtr}  = findSpikes(voltGJ,time);
  spikesRef{fCtr} = findSpikes(voltRef,time);
  
  for i = 1:length(spikesGJ{fCtr})
    meanISIGJ(fCtr,i)  = mean(diff(spikesGJ{fCtr}{i})); 
    stdISIGJ(fCtr,i)   = std(diff(spikesGJ{fCtr}{i})); 
    meanFreqGJ(fCtr,i) = mean(1./diff(spikesGJ{fCtr}{i})); 

    meanISIRef(fCtr,i)  = mean(diff(spikesRef{fCtr}{i})); 
    stdISIRef(fCtr,i)   = std(diff(spikesRef{fCtr}{i})); 
    meanFreqRef(fCtr,i) = mean(1./diff(spikesRef{fCtr}{i})); 
  end

  %%%%%%%%%%%%%%
  %%
  %% Locate the spikes to include in the mean GJ trace, those that 
  %% are not too close to either end of the edges
  %%
  
  clear idxGJ idxRef nSpikes nGJonFS
  
  for i = 1:length(spikesGJ{fCtr})
    idxGJ{i} = find(-tPre < spikesGJ{fCtr}{i} ...
                    & spikesGJ{fCtr}{i} < maxTime(fCtr) - tPost);
    nSpikes(i) = length(idxGJ{i});
    nGJonFS(i) = length(gapsOnCell{i});
  end
        
  for i = 1:length(spikesRef{fCtr})
    idxRef{i} = find(-tPre < spikesRef{fCtr}{i} ...
                     & spikesRef{fCtr}{i} < maxTime(fCtr) - tPost);
  end           
          

  %%%%%%%%%%%%
  %%
  %% Calculate mean GJ current, and mean voltage around spike
  %%
  
  allVolt1 = nan*ones(sum(nSpikes.*nGJonFS),dataLen);
  allVolt2 = nan*ones(sum(nSpikes.*nGJonFS),dataLen);
  allGJcur = nan*ones(sum(nSpikes.*nGJonFS),dataLen);
  
  k = 1;
  
  for iCell = 1:(numCells/2) % Iterate over all neurons with GJ
    for iSpike = 1:length(idxGJ{iCell})
      for iGJ = 1:length(gapsOnCell{iCell})
      % The sign indicates which direction the GJ current flows
      
        tmp = abs(time - spikesGJ{fCtr}{iCell}(idxGJ{iCell}(iSpike)));
        spikeIdx = find(min(tmp) == tmp,1);
      
        allGJcur(k,:) = sign(gapsOnCell{iCell}(iGJ)) ...
                          * GJcur(idxRange + spikeIdx, ...
                                  abs(gapsOnCell{iCell}(iGJ)));

        % allVolt1 = spiking neuron, allVolt2 = neighbour
        if(gapsOnCell{iCell}(iGJ) > 0)
          allVolt1(k,:) = voltPrim1(idxRange + spikeIdx, ...
                                    abs(gapsOnCell{iCell}(iGJ)));
          allVolt2(k,:) = voltPrim2(idxRange + spikeIdx, ...
                                    abs(gapsOnCell{iCell}(iGJ)));
          else
          allVolt1(k,:) = voltPrim2(idxRange + spikeIdx, ...
                                    abs(gapsOnCell{iCell}(iGJ)));
          allVolt2(k,:) = voltPrim1(idxRange + spikeIdx, ...
                                    abs(gapsOnCell{iCell}(iGJ)));
                    
          end
        k = k + 1;
      end
    end
  end
  
  meanGJcur(fCtr,:) = mean(allGJcur);
  meanVolt1(fCtr,:) = mean(allVolt1);
  meanVolt2(fCtr,:) = mean(allVolt2);
  
  %%%%%%%%%%%
  %%
  %% Calculate cross correlogram
  %%
  
  clear tmpnGJ tmpnRef
  
  for i = find(nGJonFS > 0)

    srcIdx = ceil(gapSrc(fCtr,i)/2);
    destIdx = ceil(gapDest(fCtr,i)/2);
      
    spikeTimesGJA = spikesGJ{fCtr}{srcIdx};
    spikeTimesGJB = spikesGJ{fCtr}{destIdx};

    spikeTimesRefA = spikesRef{fCtr}{srcIdx};
    spikeTimesRefB = spikesRef{fCtr}{destIdx};
    
    timeDiffsGJ = repmat(spikeTimesGJA,1,length(spikeTimesGJB)) ...
                   - repmat(spikeTimesGJB',length(spikeTimesGJA),1);

    timeDiffsRef = repmat(spikeTimesRefA,1,length(spikeTimesRefB)) ...
                   - repmat(spikeTimesRefB',length(spikeTimesRefA),1);

    [tmpnGJ(i,:), tmpbinGJ]   = histc(timeDiffsGJ(:), tRange);
    [tmpnRef(i,:), tmpbinRef] = histc(timeDiffsRef(:), tRange);
    
  end

  SCCCGJ(fCtr,:) = sum(tmpnGJ);
  SCCCRef(fCtr,:) = sum(tmpnRef);

end


if(gapRes ~= RGJ)
  disp('Gap resistance wrong, dont trust output. Fix this script.')
end


%%%%%%%%%%%


%%%%%%% Plot stuff

tGJrange = linspace(tPre,tPost,dataLen);

figure
p = plot(1e3*tGJrange,1e12*meanGJcur);
xlabel('Time (ms)')
ylabel('GJ current (pA)')
legend(p,pLeg)

figure
p = stairs(tRange,SCCCGJ'-SCCCRef');
legend(p,pLeg)


figure
bar(1:21,mean(meanFreqRef,2),'r'), hold on
bar(1:21,mean(meanFreqGJ,2),0.65,'k');

figure
shuntStd = std(meanFreqGJ./meanFreqRef,0,2)/sqrt(numCells(1)/2-1);
shuntMean = mean(meanFreqGJ./meanFreqRef,2);

errorbar(1:21,shuntMean,-shuntStd,+shuntStd,'k.'), hold on
bar(1:21,shuntMean,'k')
ylabel('f_{GJ}/f_{Ref}')

idx = find(parChanged == 0);
plot([0 22],[1 1]*shuntMean(idx),'r-')
