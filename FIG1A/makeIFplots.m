% To generate Figure 1A run the following MATLAB scripts:
%
% runIFscanTenFS.m
% readIFscanTenFS.m
% makeIFplots.m
%

initTime = 0.4;

% What random seeds did we use?
rsu = unique(randSeed);

figure(1), clf
figure(2), clf

for i = 1:length(rsu)
    
    rs = rsu(i);
   
    idx = find(randSeed == rs);
    
    [cur, cidx] = sort(curAmp(idx));
    
    clear freq
    
    for j = 1:length(idx)
      for k = 1:length(savedSpikeTimes{idx(j)})
        freq(j,k) = length(find(savedSpikeTimes{idx(j)}{k} > initTime));
      end    
    end
    
    % F = freq/(length(savedSpikeTimes{idx(j)})*(maxTime(idx(j))-initTime));
    F = freq/(maxTime(idx(j))-initTime);
    
    % If you ran runTenIFscan.m then the first neuron is the standard neuron
    figure(1)
    plot(1e12*cur,F(cidx,:), 'Color', [1 1 1]*0.5, 'LineWidth', 2)    
    hold on
    plot(1e12*cur,F(cidx,1),'k', 'LineWidth',2)

    xlabel('Current (pA)')
    ylabel('Frequency (Hz)')
    
    
    figure(2)
    curFiner = linspace(min(cur),max(cur),1000);
    voltFiner = interp1(cur,F(cidx,:), curFiner,'cubic');
    plot(1e12*curFiner,voltFiner,'Color',[1 1 1]*0.5)
    hold on
    plot(1e12*curFiner, voltFiner(:,1),'k')
    xlabel('Current (pA)')
    ylabel('Frequency (Hz)')
    
end



if(exist('randId'))
   title(['randId = ' num2str(randId)]) 
   saveas(gcf, ['FIGS/FS-IFplot-' num2str(randId)], 'fig')
   
else   
   figure(1)
   saveas(gcf, 'FIGS/FS-IFplot.fig', 'fig')
   saveas(gcf, 'FIGS/FS-IFplot.eps', 'psc2')
end
