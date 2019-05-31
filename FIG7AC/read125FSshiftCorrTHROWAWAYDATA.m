% To generate Figure 7C
%
% runLARGEFSwithShiftingCorr.m
% read125FSshiftCorrTHROWAWAYDATA.m
% makeShiftCorrPlot125FS.m
%

clear all
format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')


filePath = 'UTDATA/SAVED/LARGEFS-shiftingCorrFlag-saveGJcur/';

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
    numCellsInput(fileCtr)= strread(fgetl(fid), '%d');
    periodShifts(fileCtr) = strread(fgetl(fid), '%d');
    
    for i=1:periodShifts(fileCtr)
      periodLen{fileCtr}(i) = strread(fgetl(fid), '%f');
      corrFlag{fileCtr}(i) = strread(fgetl(fid), '%f');
    end
    
    fclose(fid);
    
    data = load(filenameDATA);
    
    time  = data(:,1);
    somaVolt = data(:,2:(1+numCells(fileCtr)));
    GJvolt = data(:,2+numCells(fileCtr):end);    
    
    %!!!!! Throw away GJcur here, not really needed
    %
    %% Keep only GJcur too conserve memory
    %GJcur{fileCtr} = (GJvolt(:,2:2:end) - GJvolt(:,1:2:end)) ...
    %                 / gapResistance(fileCtr);
                 
    spikeTimes = findSpikes(somaVolt, time);
    
    clear data time somaVolt GJvolt
    
    savedSpikeTimes{fileCtr} = spikeTimes;

    for i=1:numCells(fileCtr)       
      firingFreq(fileCtr,i) = length(spikeTimes{i})/maxTime(fileCtr);
    end
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
%     conMat{i} = x.conMat;
%   end   
% 
%   %figure, showFSnetwork(x.conMat, uRand)
%end
