% This code calculates the input resistance for a FS neuron in a
% population, where each neuron has nAvgGJ number of gap junctions.
%
%
% Run the following script to generate the data:
%
% calcInputResistance.m
% calcInputResistanceSecDend.m
% 
% First parse and plot the figures:
% 
% plotInputResistance.m
% plotInputResistanceSecDend.m
% 
% After the pre-parsing, a merged figure can be plotted (used in article):
% 
% plotInputResistanceMERGED.m
%
% 
clear all, close all, format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')


filePath = 'UTDATA/SAVED/LARGEinputResCheck/SecDend/';

filesRaw = dir([filePath 'FSinputResCheck*.data'])

for fileCtr = 1:length(filesRaw)

    disp(['Reading: ' filesRaw(fileCtr).name])

    filenameDATA = [filePath filesRaw(fileCtr).name];
    filenameINFO = strrep(filenameDATA, '.data', '.info');

    fid = fopen(filenameINFO, 'r');

    outputFile{fileCtr} = fgetl(fid);
    maxTime(fileCtr)    = strread(fgetl(fid), '%f');
    numCells(fileCtr)   = strread(fgetl(fid), '%d');
    numGaps(fileCtr)    = strread(fgetl(fid), '%d');

    for i=1:numGaps(fileCtr)
        [gapSource{fileCtr}{i}, gapDest{fileCtr}{i}, gapRes{fileCtr}(i)] = ...
            strread(fgetl(fid), '%s %s %f');
    end

    if(numGaps(fileCtr) == 0)
        gapResistance(fileCtr) = inf;
    else
        if(checkAllEqual(gapRes{fileCtr}))
            gapResistance(fileCtr) = gapRes{fileCtr}(1);
        else
            disp('analyseData: All gap resistances are not equal!')
            keyboard
        end
    end

    numCurs(fileCtr)    = strread(fgetl(fid), '%d');
    for i=1:numCurs(fileCtr)
       curStart(fileCtr,i) = strread(fgetl(fid), '%f');
       curEnd(fileCtr,i)   = strread(fgetl(fid), '%f');
       curAmp(fileCtr,i)   = strread(fgetl(fid), '%f');
       curLoc{fileCtr}{i}  = fgetl(fid);
       tmp = textscan(curLoc{fileCtr}{i},'/fs[%d]/soma');
       curCellNum(fileCtr,i) = tmp{1} + 1; % Matlab numbering from 1
    end
    
    fclose(fid);
    
    % Now we got to figure out which voltage traces we are interested in
    
    data = load(filenameDATA);
    time = data(:,1);
    
    % Find time point to read baseline for the neuron
    baseIdx = find(time == 0.199);
    
    for i=1:numCurs
      tIdx = find(curEnd(fileCtr, i) == time);
      if(isempty(tIdx))
         disp('Did not find exact time for curEnd.')
         disp('Have to use timestep before, NOT IMPLEMENTED - YET')
         keyboard
      end
     
      thisCell = curCellNum(fileCtr,i);
      baseVolt(fileCtr, i) = data(baseIdx, thisCell+1); %1st col is time
      peakVolt(fileCtr, i) = data(tIdx, thisCell+1);
      deltaVolt(fileCtr, i) = peakVolt(fileCtr, i) - baseVolt(fileCtr, i);
      inputRes(fileCtr, i) = deltaVolt(fileCtr, i) / curAmp(fileCtr,i);
    end
    
    
end

[foo sortIdx] = sort(numGaps);

figure
plot(2*numGaps(sortIdx)./numCells(sortIdx),1e-6*inputRes(sortIdx,:), 'k','linewidth',2)
xlabel('Number of gap junctions per FS','fontsize',24)
ylabel('Input resistance (M\Omega)','fontsize',24)
set(gca,'fontsize',20)
box off
axis tight
a = axis; a(1) = 0; a(3) = 0; axis(a);

saveas(gcf,'FIGS/FS-inputRes-for-GJ.fig','fig')
saveas(gcf,'FIGS/FS-inputRes-for-GJ.eps','psc2')


figure
meanInputRes = mean(inputRes,2);
stdInputRes = std(inputRes,0,2);
plot(2*numGaps(sortIdx)./numCells,1e-6*meanInputRes(sortIdx), ...
    'k','linewidth',2)
hold on
errorbar(2*numGaps(sortIdx)./numCells(sortIdx),1e-6*meanInputRes(sortIdx), ...
         -1e-6*stdInputRes(sortIdx),1e-6*stdInputRes(sortIdx), ...
         'k.', 'linewidth',2)

xlabel('Number of gap junctions per FS','fontsize',24)
ylabel('Input resistance (M\Omega)','fontsize',24)
set(gca,'fontsize',20)
box off
axis tight
a = axis; a(1) = 0-0.2; a(3) = 0; axis(a);

saveas(gcf,'FIGS/FS-inputRes-for-GJ-mean.fig','fig')
saveas(gcf,'FIGS/FS-inputRes-for-GJ-mean.eps','psc2')

%%%%% Save data

nGapsSec = 2*numGaps(sortIdx)./numCells(sortIdx);
inputResSec = meanInputRes(sortIdx);
inputResErrSec = stdInputRes(sortIdx);

curPath = pwd;
cd(filePath)
save secInputRes.mat nGapsSec inputResSec inputResErrSec
cd(curPath)
