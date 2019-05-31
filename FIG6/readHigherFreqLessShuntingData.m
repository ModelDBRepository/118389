%
% Read the data...
%
% The plot shows that higher input frequency will lead to a relative
% lower shunting, and thus more spikes (relatively speaking)
%
% 
% To generate Figure 6A:
%
% runTenFShigherFreqLessShunting.m
% readHigherFreqLessShuntingData.m
% makeHigherFreqLessShuntingPlot.m
%
%

clear all
format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')

%
% Load datafiles, non connected and 0.5nS

filePath = 'UTDATA/SAVED/TenFS-higherFreqLessShunt/';
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
    volt  = data(:,2:end);

    spikeTimes = findSpikes(volt, time);

    tmp = corrcoef(volt(:,1),volt(:,2));
    corrCoefficient(fileCtr) = tmp(1,2);
    
    % Gauss curve, std 5ms
    gCurve = normpdf(-15e-3:1e-4:15e-3,0,5e-3);   
    tmpL = length(gCurve);
    tmpA = conv(volt(:,1),gCurve);
    tmpB = conv(volt(:,2),gCurve);
    tmp = corrcoef(tmpA(tmpL:end-tmpL),tmpB(tmpL:end-tmpL));
    convCorrCoeff(fileCtr) = tmp(1,2);
    
    clear data time volt

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
   axis(1.1*axis)
end
