%
% Read the data...
%
% The plot shows that higher input frequency will lead to a relative
% lower shunting, and thus more spikes (relatively speaking)
%
% Figure 6B:
% runTenFShigherFreqLessShuntingSaveGJcur.m
% readHigherFreqLessShuntingDataSavedGJcur.m
% makeGJvoltageDiffPlot.m
%
%
% Figure 6C:
% runTenFShigherFreqLessShuntingSaveGJcur.m   (same as in 6B)
% readHigherFreqLessShuntingDataSavedGJcur.m
% makeSpikeCenteredGJcurPlot.m
% makeSpikeCenteredGJcurPlotLONGER.m
%

clear all
format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')


%
% Load datafiles, non connected and 0.5nS

filePath = 'UTDATA/SAVED/TenFS-higherFreqLessShunt-saveGJcur/';
filesRaw = dir([filePath '*id'  '*.data'])


for fileCtr = 1:length(filesRaw)
    disp(['Reading: ' filesRaw(fileCtr).name])

    filenameDATA = [filePath filesRaw(fileCtr).name];
    filenameINFO = strrep(filenameDATA, '.data', '.info');

    saveFileINFO{fileCtr} = filenameINFO;

    %% Läs in körningens parametrar

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


    inputInfo{fileCtr}    = fgetl(fid);

    corrRudolph(fileCtr)  = strread(fgetl(fid), '%f');
    upFreq(fileCtr)       = strread(fgetl(fid), '%f');
    noiseFreq(fileCtr)    = strread(fgetl(fid), '%f');
    maxInputTime(fileCtr) = strread(fgetl(fid), '%f');
    allowVar(fileCtr)     = strread(fgetl(fid), '%d');
    randSeed(fileCtr)     = strread(fgetl(fid), '%d');

    fclose(fid);

    data = load(filenameDATA);

    time  = data(:,1);
    somaVolt = data(:,2:(1+numCells(fileCtr)));
    GJvolt = data(:,2+numCells(fileCtr):end);

    GJcur{fileCtr} = (GJvolt(:,2:2:end) - GJvolt(:,1:2:end)) ...
                       / gapResistance(fileCtr);

    % This is so that those runs without GJ should be marked with NaN
    % for easier error detection
    if(exist('GJvoltCov'))
      GJvoltCov(fileCtr,:) = NaN; 
    end
                   
    for i=1:(size(GJvolt,2)/2)
      tmp = cov(GJvolt(:,2*i-1),GJvolt(:,2*i));
      GJvoltCov(fileCtr,i) = tmp(1);
    end    
                   
                   
    spikeTimes = findSpikes(somaVolt, time);

    clear data time somaVolt GJvolt

    savedSpikeTimes{fileCtr} = spikeTimes;

end

if(~(checkAllEqual(corrRudolph) ...
     & checkAllEqual(noiseFreq) ...
     & checkAllEqual(maxTime) ...
     & checkAllEqual(allowVar) ...
     & checkAllEqual(maxInputTime) ...
     & checkAllEqual(numCells)))

  disp('analyseData: Error! All parameters are note equal!')
  keyboard

end


for uRand = unique(randSeed)
   x = load([filePath 'conMat-' num2str(uRand) '.mat']);

   for i = find(randSeed == uRand)
     conMat{i} = x.conMat;
   end

   % figure, showFSnetwork(x.conMat, uRand)
end

