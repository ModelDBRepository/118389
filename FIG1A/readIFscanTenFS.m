% To generate Figure 1A run the following MATLAB scripts:
%
% runIFscanTenFS.m
% readIFscanTenFS.m
% makeIFplots.m
%

% Matlab helper scripts are located here
path(path,'../matlabScripts')



if(~exist('randId'))
  clear all
  format compact
  randTag = [];
else
  disp('Clear randId to read all data')
  randTag = num2str(randId);
end
  
filePath = 'UTDATA/SAVED/TenFSIFscanHighRES/';

filesRaw = dir([filePath 'TenInhomoFS-curInject-IFscan-ID' randTag '*.data'])

disp(['Reading ' num2str(length(filesRaw)) ' data-files'])

for fileCtr = 1:length(filesRaw)
    disp(['Reading: ' filesRaw(fileCtr).name])

    filenameDATA = [filePath filesRaw(fileCtr).name];
    filenameINFO = strrep(filenameDATA, '.data', '.info');

    saveFileINFO{fileCtr} = filenameINFO;

    tmp = regexp(filenameDATA,'ID[0-9]+','match');
    randSeed(fileCtr) = str2num(tmp{1}(3:end));
    
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
        
    numCur(fileCtr)       = strread(fgetl(fid), '%d');

    for i = 1:numCur(fileCtr)
      curStart(fileCtr) = strread(fgetl(fid), '%f');
      curEnd(fileCtr)   = strread(fgetl(fid), '%f');

      tmpAmp = strread(fgetl(fid), '%f');
      
      if(i > 1 & tmpAmp ~= curAmp(fileCtr))
         disp('WARNING!! All injected currents do not have same amplitude!')
      end
      
      curAmp(fileCtr)   = tmpAmp;
      
      curLoc(fileCtr)   = strread(fgetl(fid), '%s');    

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

end

