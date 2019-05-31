%
% To generate the supplementary figures S5:
%
% S5A
% runTenFSsensitivity.m
% readTenFSsensitivity
% makeShuntingSensitivityFigure.m
% 
%
% S5B
% runTenFSsensitivity.m     (same as in S5A)
% readTenFSsensitivity.m
% makeCorrPairFigure.m
%
%
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

% Make sure that we are not still writing to the file

for i = 1:length(filesData)
  if(now() - filesData(i).datenum > 0.005)
    fOk(i) = 1;
  else
    fOk(i) = 0;
  end
end

filesData(~fOk) = [];

% Do we have all 21 simulations with this randID done?

for fCtr = 1:length(filesData)

  tmp = regexp(filesData(fCtr).name,'ID[0-9]+','match');
  randId(fCtr) = str2num(tmp{1}(3:end));

end

uId = unique(randId);

for iId = 1:length(uId);
  idx = find(randId == uId(iId));
  
  if(length(idx) ~= 21)
    filesData(idx) = []; % No, remove the odd birds!   
    randId(idx) = [];
  end
end
  
clear randId


RGJ = 2e9;


tPre  = -10e-3; tPost =  10e-3; 

tRange = linspace(-50e-3,50e-3,100);

parType = {'g_{Na}', 'g_{KA}', 'g_{Kv3.1/3.2}', 'g_{Kv1.3}', ...
           '\tau_m (Na)', '\tau_h (Na)', '\tau_m (KA)', '\tau_h (KA)', ...
           '\tau_{Kv3.1/3.2}','\tau_{Kv1.3}'};

%matlabpool       
       
for fCtr = 1:length(filesData)
  disp(sprintf('Reading %s', filesData(fCtr).name))

  data = load(sprintf('UTDATA/%s', filesData(fCtr).name));

  tmp = regexp(filesData(fCtr).name,'ID[0-9]+','match');
  randId(fCtr) = str2num(tmp{1}(3:end));

%  % Only load connection matrix if we really need to use it
%  if(fCtr == 1 | randId(fCtr-1) ~= randId(fCtr))
%    conMat = ...
%      load(sprintf('INDATA/connectionMatrix-ID%d.mat', randId(fCtr)));
%  end

  tmp = regexp(filesData(fCtr).name,'freq-[.0-9]+Hz','match');
  inFreq(fCtr) = str2num(tmp{1}(6:end-2));
  
  infoFile = sprintf('INDATA/%s',strrep(filesData(fCtr).name,'.data','.info'));
  
  fid = fopen(infoFile,'r');
  
  dataFileName   = fgetl(fid);
  maxTime(fCtr)  = strread(fgetl(fid), '%f');
  numCells(fCtr) = strread(fgetl(fid), '%d');
  tmp            = fgetl(fid);
  FSpars(fCtr,:) = strread(tmp, '%f','delimiter',' ');
  tmp            = fgetl(fid);
  tmpReg         = regexp(tmp,'ID','match'); 
  if(length(tmpReg) > 0) % Blue Gene generated data, skip this row
    disp('Data generated on Blue Gene, skip this line')
    numGJ(fCtr)    = strread(fgetl(fid), '%d');
  else % Not Blue Gene data, was no extra row, use this line as numGJ
    disp('Non-blue Gene data read')  
    numGJ(fCtr)    = strread(tmp, '%d');
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
    
    % This estimate is only valid for regularly spiking neurons    
    %meanFreqGJ(fCtr,i) = mean(1./diff(spikesGJ{fCtr}{i})); 
    % This one however works:
    meanFreqGJ(fCtr,i) = 1./mean(diff(spikesGJ{fCtr}{i})); 
    
    %meanFreqGJ(fCtr,i) = length(spikesGJ{fCtr}{i})/maxTime(fCtr); 

    meanISIRef(fCtr,i)  = mean(diff(spikesRef{fCtr}{i})); 
    stdISIRef(fCtr,i)   = std(diff(spikesRef{fCtr}{i})); 
    % Only valid for regularly spiking, otherwise small ISI weighted
    % too heavilly
    %meanFreqRef(fCtr,i) = mean(1./diff(spikesRef{fCtr}{i})); 
    meanFreqRef(fCtr,i) = 1./mean(diff(spikesRef{fCtr}{i})); 
    
    %meanFreqRef(fCtr,i) = length(spikesRef{fCtr}{i})/maxTime(fCtr); 
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

    srcIdx = 1 + floor(gapSrc(fCtr,i)/2);
    destIdx = 1 + floor(gapDest(fCtr,i)/2);
      
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

    % Count number of paired spikes
    
    %tmp = abs(timeDiffsGJ) < 5e-3;
    %freqPairsGJ(fCtr,i) = nnz(sum(tmp,1)) + nnz(sum(tmp,2));
    
    %tmp = abs(timeDiffsRef) < 5e-3;
    %freqPairsRef(fCtr,i) = nnz(sum(tmp,1)) + nnz(sum(tmp,2));
    
    % Count number of spike pairs
    
    freqPairsGJ(fCtr,i) = nnz(abs(timeDiffsGJ) < 5e-3) ...
                           / maxTime(fCtr);
    freqPairsRef(fCtr,i) = nnz(abs(timeDiffsRef) < 5e-3) ...
                           / maxTime(fCtr);
    
  end

  crossCorrGJ(fCtr,:) = sum(tmpnGJ);
  crossCorrRef(fCtr,:) = sum(tmpnRef);

end


%matlabpool close

if(gapRes ~= RGJ)
  disp('Gap resistance wrong, dont trust output. Fix this script.')
end


%%%%%%%%%%%

uPars = unique(FSpars,'rows');

% We have to resort the rows

[foo,rowIdx] = sortrows(-abs(uPars-1) - 1e-3*uPars);
uPars = uPars(rowIdx,:);
refIdx = find(prod(double(uPars == 1),2) == 1);
uPars = uPars([1:(refIdx-1), (refIdx+1):end, refIdx],:);

nFiles = size(FSpars,1);  

if(size(uPars,1) ~= 21)
  disp('ERROR require 21 different simulations') 
  keyboard
end

for iPars = 1:size(uPars,1)
  parIdx = find(sum(abs(repmat(uPars(iPars,:),nFiles,1) - FSpars),2) == 0);

  meanGJcurPAR(iPars,:) = mean(meanGJcur(parIdx,:));
  crossCorrGJPAR(iPars,:) = sum(crossCorrGJ(parIdx,:));
  crossCorrRefPAR(iPars,:) = sum(crossCorrRef(parIdx,:));
  meanFreqGJPAR(iPars,:) = mean(mean(meanFreqGJ(parIdx,:)));
  meanFreqRefPAR(iPars,:) = mean(mean(meanFreqRef(parIdx,:)));
  tmp = freqPairsGJ(parIdx,:);
  freqPairsGJPAR(iPars,:) = mean(tmp(:));
  freqPairsGJPARstdm(iPars,:) = std(tmp(:))/sqrt(length(tmp(:))-1);
  
  tmp = freqPairsRef(parIdx,:);
  freqPairsRefPAR(iPars,:) = mean(tmp(:));
  freqPairsRefPARstdm(iPars,:) = std(tmp(:))/sqrt(length(tmp(:))-1);
  
  pIdx = find(uPars(iPars,:)-1);
  if(length(pIdx) > 1)
    pLeg{iPars} = 'More than one modified';
    parChanged(iPars) = NaN;
    
  elseif(isempty(pIdx))
    pLeg{iPars} = 'Reference';  
    parChanged(iPars) = 0;
  else
    pLeg{iPars} = [sprintf('%s %.0f', parType{pIdx}, ...
                            (uPars(iPars,pIdx)-1)*100) '%' ];
    parChanged(iPars) = pIdx;            
  end  

end

%%%%%%% Plot stuff

tGJrange = linspace(tPre,tPost,dataLen);

figure
p = plot(1e3*tGJrange,1e12*meanGJcurPAR);
xlabel('Time (ms)','fontsize',16)
ylabel('GJ current (pA)','fontsize',16)
set(gca,'fontsize',16)
legend(p,pLeg)
saveas(gcf,'FIGS/TenFS-sense-meanGJcur.fig','fig')
saveas(gcf,'FIGS/TenFS-sense-meanGJcur.eps','psc2')

figure
p = stairs(1e3*tRange,crossCorrGJPAR'-crossCorrRefPAR');
xlabel('Time (ms)','fontsize',16)
ylabel('Count','fontsize',16)
set(gca,'fontsize',16)
legend(p,pLeg)
saveas(gcf,'FIGS/TenFS-sense-crossCorr.fig','fig')
saveas(gcf,'FIGS/TenFS-sense-crossCorr.eps','psc2')


figure
bar(1:21,mean(meanFreqRefPAR,2),'r'), hold on
bar(1:21,mean(meanFreqGJPAR,2),0.65,'k');
ylabel('Frequency (Hz)','fontsize',16)
set(gca,'fontsize',16)
saveas(gcf,'FIGS/TenFS-sense-meanFreq.fig','fig')
saveas(gcf,'FIGS/TenFS-sense-meanFreq.eps','psc2')

figure
shuntStd = std(meanFreqGJPAR./meanFreqRefPAR,0,2)/sqrt(numCells(1)*length(parIdx)/2-1);
shuntMean = mean(meanFreqGJPAR./meanFreqRefPAR,2);

bar(1:21,shuntMean,'k'), hold on
errorbar(1:21,shuntMean,-shuntStd,+shuntStd,'.','color',[0.2 0.2 0.2])
ylabel('f_{GJ}/f_{Ref}')

idx = find(parChanged == 0);
plot([0 22],[1 1]*shuntMean(idx),'r-')

saveas(gcf,'FIGS/TenFS-sense-meanShunt.fig','fig')
saveas(gcf,'FIGS/TenFS-sense-meanShunt.eps','psc2')

save('TenFS-BlueGene.mat', ...
     'tGJrange', 'meanGJcurPAR', 'meanFreqRefPAR', 'meanFreqGJPAR', ...
     'shuntMean', 'shuntStd', ...
     'crossCorrGJPAR', 'crossCorrRefPAR', ...
     'freqPairsGJ','freqPairsRef','FSpars', ...
     'freqPairsGJPARstdm', 'freqPairsRefPARstdm', ...
     'freqPairsGJPAR', 'freqPairsRefPAR','pLeg', 'parIdx');    
