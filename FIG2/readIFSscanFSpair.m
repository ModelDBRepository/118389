% To generate Figure 5A run the following MATLAB scripts:
% 
% runTwoFSwithGJforIFplots.m
% readIFSscanFSpair.m
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
  
% filePath = 'UTDATA/SAVED/';
%filePath = 'UTDATA/SAVED/lenKA-20/';
%filePath = 'UTDATA/SAVED/6.87coup/';
%filePath = 'UTDATA/SAVED/GJscan/';
filePath = 'UTDATA/SAVED/';

filesRaw = dir([filePath 'StandardFS*ID' randTag '*.data'])

disp(['Reading ' num2str(length(filesRaw)) ' data-files'])

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
    
    
    numCur(fileCtr)       = strread(fgetl(fid), '%d');

%    fgetl(fid); % Numcells again
    %fgetl(fid) % Gamma shape, throw away info... ;)
    
    for i = 1:numCur(fileCtr)
      curStart(fileCtr) = strread(fgetl(fid), '%f');
      curEnd(fileCtr)   = strread(fgetl(fid), '%f');

      tmpAmp = strread(fgetl(fid), '%f');
      
      if(i > 1 & tmpAmp ~= curAmp(fileCtr))
         disp('WARNING!! All injected currents do not have same amplitude!')
      end
      
      if(i == 1)
        curAmp(fileCtr)   = tmpAmp;
      end
        
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

