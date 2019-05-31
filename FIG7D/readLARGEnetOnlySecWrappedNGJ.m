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

clear all
format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')


filePath = 'UTDATA/SAVED/LARGEFSGJAllUpstateOnlySecWrappedNGJscan/';

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
    
%    data{fileCtr} = load(filenameDATA);
    data = load(filenameDATA);
    
%    time  = data{fileCtr}(:,1);
%    volt  = data{fileCtr}(:,2:end);
    time  = data(:,1);
    volt  = data(:,2:end);

    spikeTimes = findSpikes(volt, time);
    
    clear data time volt
    
    savedSpikeTimes{fileCtr} = spikeTimes;

end

if(~(checkAllEqual(corrRudolph) ...
     & checkAllEqual(upFreq) ...
     & checkAllEqual(noiseFreq) ...
     & checkAllEqual(maxTime) ...
     & checkAllEqual(allowVar) ...
     & checkAllEqual(maxInputTime) ...
     & checkAllEqual(numCells)))
 
  disp('analyseData: Error! All parameters are note equal!')
  keyboard
   
end


%for uRand = unique(randSeed)
%   x = load([filePath 'conMat-' num2str(uRand) '.mat']);
%   
%   for i = find(randSeed == uRand)
%     conMat{i} = full(x.conMat);
%   end   
% 
%%   figure, showFSnetwork(x.conMat, uRand)
%%   axis(1.1*axis)
%end
