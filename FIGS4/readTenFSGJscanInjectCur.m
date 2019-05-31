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

clear all
format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')


filePath = 'UTDATA/SAVED/TenFSGJscanCurInject/';

filesRaw = dir([filePath '*id'  '*.data'])

for fileCtr = 1:length(filesRaw)
    disp(['Reading: ' filesRaw(fileCtr).name])

    filenameDATA = [filePath filesRaw(fileCtr).name];
    filenameINFO = strrep(filenameDATA, '.data', '.info');

    saveFileINFO{fileCtr} = filenameINFO;
    
    tmp = regexp(filenameDATA,'[0-9]+','match');
    conMatRandSeed(fileCtr) = str2num(tmp{1});
    
    
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

    for i=1:length(spikeTimes)
      firingFreq(fileCtr,i) = length(spikeTimes{i});
    end

end

if(~(checkAllEqual(maxTime) ...
      & checkAllEqual(numCells)))
 
  disp('analyseData: Error! All parameters are note equal!')
  keyboard
   
end


for uRand = unique(conMatRandSeed)
   x = load([filePath 'conMat-' num2str(uRand) '.mat']);
   
   for i = find(conMatRandSeed == uRand)
     conMat{i} = x.conMat;
   end   
 
   %figure, showFSnetwork(x.conMat, uRand)
end
