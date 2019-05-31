% To generate Figure 5A run the following MATLAB scripts:
% 
% runTwoFSwithGJforIFplots.m
% readIFSscanFSpair.m
% makeIFplots.m
%

initTime = 0.4;


figure(1), clf
figure(2), clf

for i = 1 %length(rsu)
    
    %rs = rsu(i);
   
    %idx = find(randSeed == rs);
    idx = 1:fileCtr;
    
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

%    pA = plot(1e12*cur,F(cidx,1), 'k-', 'LineWidth', 2);   % Ref
%    hold on
    pB = plot(1e12*cur,F(cidx,2), 'k', 'LineWidth', 2);   % GJ to similar act
    hold on
    pC = plot(1e12*cur,F(cidx,4), 'k--', 'LineWidth', 2);   % GJ to half act
    pD = plot(1e12*cur,F(cidx,6), 'r--', 'LineWidth', 2);    % GJ to no act
    pE = plot(1e12*cur,F(cidx,8), 'r-', 'LineWidth', 2);   % GJ to hyper act
%
%    legend([pA(1) pB(1) pC(1) pD(1) pE(1)], ...
%           'Unconnected reference', ...
%           'Coupled to identical', ...
%           'Coupled to half activated', ...
%           'Coupled to no activation', ...
%           'Coupled to hyperpolarised');

    legend([pB(1) pC(1) pD(1) pE(1)], ...
           'Identical', ...
           'Half current', ...
           'No current', ...
           'Hyperpolarising', ...
           'Location', 'Best');
       
    box off   
       
%    plot(1e12*cur,F(cidx,:), 'Color', [1 1 1]*0.5, 'LineWidth', 2)    
%    hold on
%    plot(1e12*cur,F(cidx,1),'k', 'LineWidth',2)

    xlabel('Current (pA)','fontsize',24)
    ylabel('Frequency (Hz)','fontsize',24)
    set(gca,'FontSize',20)
    title('Effect of coupled neighbours input','fontsize',24)
    
    figure(2)
    curFiner = linspace(min(cur),max(cur),1000);
    voltFiner = interp1(cur,F(cidx,:), curFiner,'cubic');
    plot(1e12*curFiner,voltFiner,'Color',[1 1 1]*0.5)
    hold on
    plot(1e12*curFiner, voltFiner(:,1),'k')
    xlabel('Current (pA)')
    ylabel('Frequency (Hz)')
    
end



figure(1)
saveas(gcf, 'FIGS/FS-IFplot-effect-of-neighbour-input.fig', 'fig')
