% The purpose of this script is to plot the gap junction currents
% prior and after a spike for the neuron.
%
%
% Run simulation with: runTenInhomoFSGJcorrVariationSaveGJcur.m
% Read data with: readTenInhomoFScorrVarWithGJcur.m
%

close all


% Step 1, load the data and calculate the GJ current
% This is now done in the read-file (see comment above)


% Step 2, Identify the gap junctions to each neuron
clear GJcons

for fileCtr = 1:length(savedSpikeTimes)
  for i=1:length(savedSpikeTimes{fileCtr})
    GJcons{fileCtr}{i} = [];
  end

  for i=1:max(conMat{fileCtr}(:))
    % Symmetric matrix, since GJ are two way connections
    [x,y] = find(conMat{fileCtr} == i);

    x = x(1);
    y = y(1);

    % Positive value indicates our neuron is source, negative value
    % indicates it is the dest neuron in a GJ coupled pair
    GJcons{fileCtr}{x} = [GJcons{fileCtr}{x} i];
    GJcons{fileCtr}{y} = [GJcons{fileCtr}{y} -i];

  end
end



% Step 3, identify the spikes

% Step 4, extract the current between 10 ms prior and 10 ms after a
% spike, probably only 10 ms will be used later, but lets do it for
% lots of data first.

% OBS, be careful with the sign, depending of it is the source or dest
% neuron that spikes. Incoming positive charges is defined as positive
% current here. See comment below for electrophys. standard.

clear curTraces
disp('Time to gather data')

for fileCtr = 1:length(savedSpikeTimes)

  disp(['Processing file ' num2str(fileCtr) ...
        '(' num2str(length(savedSpikeTimes)) ')'])
  tUse = linspace(0, maxTime(fileCtr), size(GJcur{fileCtr},1));

  curTraces{fileCtr} = [];

  % disp(['Looping: fileCtr = ' num2str(fileCtr)])

  if(gapResistance(fileCtr) < inf)

    for cellCtr = 1:length(savedSpikeTimes{fileCtr})
      % disp(['Looping: cellCtr = ' num2str(cellCtr)])

      for i = 1:length(savedSpikeTimes{fileCtr}{cellCtr})

        % disp(['Looping: i = ' num2str(i)])

        % Two places to change if you want to change time window, both
        % lines below, and for tIdx further down.

        tPre = savedSpikeTimes{fileCtr}{cellCtr}(i) - 10e-3;
        tSpik = savedSpikeTimes{fileCtr}{cellCtr}(i);
        tPost = savedSpikeTimes{fileCtr}{cellCtr}(i) + 10e-3;

        % Throw away the ones at the edges, we want enough data.
        if(0 <= tPre && tPost < maxTime(fileCtr))

          tIdx = (-100:1:100) + find(abs(tSpik - tUse) == min(abs(tSpik-tUse)),1);

          for j=1:length(GJcons{fileCtr}{cellCtr})
            neighIdx = GJcons{fileCtr}{cellCtr}(j);

            % All gap junctions in the simulation are numbered
            % abs(neighIdx) = GJ id-tag
            % sign(neighIdx) = flag to indicate direction of positive cur.
     
            curTraces{fileCtr}(:,end+1) = ...
                GJcur{fileCtr}(tIdx, abs(neighIdx)) ...
                * sign(neighIdx);
          end
        else
          % disp('Time window outside boundaries, throwing away')
        end
      end
    end
  else
    disp('Inf GJ skipping')
  end
end

% Sum the currents together for neurons with same pMix value
% obs, pCorr = 1 - pMix

upMix = unique(pMix);

% Reverse order, to make plot legend look nicer, we want the maximal
% curve to be at the top of the legend for easy reading.
upMix = upMix(end:-1:1);

clear meanCurTrace stdeCurTrace

for pCtr = 1:length(upMix)

  pIdx = find(pMix == upMix(pCtr));
  
  % Remove unconnected runs. ie where gap resistance is infinite
  pIdx(find(isinf(gapResistance(pIdx)))) = [];
    
  if(nnz(diff(gapResistance(pIdx))))
     disp('All gap junctions does not have same resistance, not supported!')
     keyboard
  end

  % Add all curTraces together
  
  allCurTraces = [];
  
  for i=1:length(pIdx)
     allCurTraces = [allCurTraces curTraces{pIdx(i)}];
  end
   
  meanCurTrace(:,pCtr) = mean(allCurTraces,2);
  stdeCurTrace(:,pCtr) = std(allCurTraces,0,2) / ...
                           sqrt(size(allCurTraces,1) -1);
                     
  clear allCurTraces                     
  
end

% Plotting
% Since electrophysiologists define positive current as outward
% current we need to multiply all currents by -1. 

tSteps = linspace(-10,10,201);

figure
p = plot(tSteps,-1e12*meanCurTrace,'linewidth',2);

clear pLeg

for i=1:length(upMix)
  pLeg{i} = sprintf('Shared input %.2f', (1-upMix(i))^2);
end

legend(p,pLeg)
xlabel('Time (ms)','fontsize',20)
ylabel('Current (pA)','fontsize',20)
title('Current through gap junctions','fontsize',24)
set(gca,'FontSize',20)
box off

saveas(p(1), 'FIGS/TenFS/GJ-current-pCorr-plot.fig', 'fig')
saveas(p(1), 'FIGS/TenFS/GJ-current-pCorr-plot.eps', 'psc2')


figure
p2 = plot(tSteps,-1e12*meanCurTrace(:,1:2:end),'linewidth',2);
clear pLeg

for i=1:2:length(upMix)
  pLeg{(i+1)/2} = sprintf('Shared input %.1f', (1-upMix(i))^2);
end

legend(p2,pLeg)
xlabel('Time (ms)','fontsize',20)
ylabel('Current (pA)','fontsize',20)
title('Current through gap junctions','fontsize',24)
set(gca,'FontSize',20)
box off

saveas(p2(1), 'FIGS/TenFS/GJ-current-pCorr-plot-cleaner.fig', 'fig')
saveas(p2(1), 'FIGS/TenFS/GJ-current-pCorr-plot-cleaner.eps', 'psc2')

