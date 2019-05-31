function [gapResistance, curCoupling, spikeCoupling] = makeGapCalibrateFigureCond(filePath, fileMask, baselineTime, spikeRange, injectCurRange)

filesRaw = dir([filePath fileMask])

if(isempty(filesRaw))
  disp('You must run the simulation first to get output')
end


for fileCtr = 1:length(filesRaw)
    disp(['Reading: ' filesRaw(fileCtr).name])

    filenameDATA = [filePath filesRaw(fileCtr).name]
    filenameINFO = strrep(filenameDATA, '.data', '.info')

    %% Läs in körningens parametrar
    
    fid = fopen(filenameINFO, 'r');
    
    outputFile = strread(fgetl(fid), '%s');
    maxTime = strread(fgetl(fid), '%f');
    numCells = strread(fgetl(fid), '%f');
    masterTarget = strread(fgetl(fid), '%s');
    slaveTarget = strread(fgetl(fid), '%s');
    masterFile = strread(fgetl(fid), '%s');
    slaveFile = strread(fgetl(fid), '%s');

    numGaps = strread(fgetl(fid), '%d');
    
    clear gapSource gapDest gapRes
    
    for iGap = 1:numGaps
        [gapSource{iGap} gapSource{iGap} gapRes(iGap)] = ...
            strread(fgetl(fid), '%s %s %f');
        
        if(gapRes(1) ~= gapRes(iGap))
            disp('makeGapCalibrateFigure: Warning, gap resistances differ...')
        end
    end
   
    if(numGaps > 0)
      gapResistance(fileCtr) = gapRes(1);
    else
      gapResistance(fileCtr) = inf;
    end
      
    numPulses = strread(fgetl(fid), '%d');
   
    clear pulseLoc
    for iPul = 1:numPulses
         [pulseStart(iPul) pulseEnd(iPul) pulseCurrent(iPul) ...
                 pulseLoc{iPul}]= strread(fgetl(fid), '%f %f %f %s');
    end

    fclose(fid);
    
    %% Läs in data
    
    data = load(filenameDATA);
    
    t = data(:,1);
    v = data(:,2:3);

    bIdx = find(baselineTime == t);
    sIdx = find(spikeRange(1) <= t & t <= spikeRange(2));
    cIdx = find(injectCurRange(1) <= t & t <= injectCurRange(2));
    
    masterBaseline = mean(v(bIdx,1))
    slaveBaseline = mean(v(bIdx,2))
    masterDepolSpike = max(v(sIdx,1))
    slaveDepolSpike = max(v(sIdx,2))
    masterDepolCur = max(v(cIdx,1))
    slaveDepolCur = max(v(cIdx,2))

    spikeCoupling(fileCtr) = (slaveDepolSpike - slaveBaseline) ...
                           / (masterDepolSpike - masterBaseline);

    curCoupling(fileCtr) = (slaveDepolCur - slaveBaseline) ...
                         / (masterDepolCur - masterBaseline);
    
end


figure(1), clf
[foo nIdx] = sort(gapResistance);

p(1) = plot(1e9./gapResistance(nIdx), curCoupling(nIdx), 'k', ...
         'linewidth',2); hold on
p(2) = plot(1e9./gapResistance(nIdx), spikeCoupling(nIdx), 'k--', ...
         'linewidth',2)
xlabel('Gap conductance (nS)','fontsize',24)
ylabel('Coupling','fontsize',24)
phandle = legend(p, 'Steady-state coupling', 'Spike coupling', ...
                 'location','best')
set(gca,'fontsize',20)
axis tight
box off
gapResistance
spikeCoupling
curCoupling

figName = strcat(strcat(filePath, outputFile), '.fig')

saveas(phandle, [filePath 'fsGalCalibrate.fig'], 'fig')
saveas(phandle, [filePath 'fsGalCalibrate.eps'], 'psc2')
