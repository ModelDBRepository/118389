% 
% To generate Figure 6A:
%
% runTenFShigherFreqLessShunting.m
% readHigherFreqLessShuntingData.m
% makeHigherFreqLessShuntingPlot.m
%
%
% This plot shows that higher input frequency will lead to a relative
% lower shunting, and thus more spikes (relatively speaking)
%
% Calculate the firing frequency

clear firingFreq allFreqNC allFreqGJ
clear avgFreqNC stdeFreqNC avgFreqGJ stdeFreqGJ 
clear avgRelFreqGJNC stdeRelFreqGJNC
clear avgFracRemoved stdeFracRemoved


for i = 1:length(savedSpikeTimes)
  for j = 1:length(savedSpikeTimes{i})
    firingFreq(i,j) = length(savedSpikeTimes{i}{j});
  end
end

uUpFreq = unique(upFreq);

for uIdx = 1:length(uUpFreq)
  runIdxNC = find(upFreq == uUpFreq(uIdx) ...
                  & numGaps == 0); 
  runIdxGJ = find(upFreq == uUpFreq(uIdx) ...
                  & numGaps == 15); 

  if(length(runIdxNC) ~= length(runIdxGJ))
    disp('Making sure there are one of GJ and NC runs')
    % GJ körningen görs först
    missingSeed = setdiff(randSeed(runIdxGJ), randSeed(runIdxNC));
    
    % Remove the one without a matching NC run
    runIdxGJ(find(randSeed(runIdxGJ) == missingSeed)) = [];
    
  end
              
  if(nnz(randSeed(runIdxNC) - randSeed(runIdxGJ)) > 0)
     disp('Warning, different ordering, relative freq will be wrong!')
     keyboard
  end

                       
  allFreqNC{uIdx} = firingFreq(runIdxNC,:);
  allFreqGJ{uIdx} = firingFreq(runIdxGJ,:);
  
  avgFreqNC(uIdx) = mean(allFreqNC{uIdx}(:));
  stdeFreqNC(uIdx) = std(allFreqNC{uIdx}(:)) ...
                     /sqrt(length(allFreqNC{uIdx}(:))-1);

  avgFreqGJ(uIdx) = mean(allFreqGJ{uIdx}(:));
  stdeFreqGJ(uIdx) = std(allFreqGJ{uIdx}(:)) ...
                      /sqrt(length(allFreqGJ{uIdx}(:))-1);

  %
  % Normalise GJ connected firing by NC firing
  
  
  avgRelFreqGJNC(uIdx) = mean(allFreqGJ{uIdx}(:)./allFreqNC{uIdx}(:));
  stdeRelFreqGJNC(uIdx) = std(allFreqGJ{uIdx}(:)./allFreqNC{uIdx}(:)) ...
                            /sqrt(length(allFreqNC{uIdx}(:))-1);  

  % Average fraction of spikes removed
  avgFracRemoved(uIdx)  = mean((allFreqNC{uIdx}(:) ...
                                 - allFreqGJ{uIdx}(:)) ...
                               ./ allFreqNC{uIdx}(:));
  stdeFracRemoved(uIdx) = std((allFreqNC{uIdx}(:) ...
                                - allFreqGJ{uIdx}(:)) ...
                               ./ allFreqNC{uIdx}(:)) ...
                           /sqrt(length(allFreqNC{uIdx}(:))-1);
                           
                        
  % Soma potential correlation coefficient
  allCorrCoeffNC{uIdx} = corrCoefficient(runIdxNC);
  allCorrCoeffGJ{uIdx} = corrCoefficient(runIdxGJ);
  
  meanCorrCoeffNC(uIdx) = mean(allCorrCoeffNC{uIdx});
  stdeCorrCoeffNC(uIdx) = std(allCorrCoeffNC{uIdx}) ...
                           / sqrt(length(allCorrCoeffNC{uIdx})-1);

  meanCorrCoeffGJ(uIdx) = mean(allCorrCoeffGJ{uIdx});
  stdeCorrCoeffGJ(uIdx) = std(allCorrCoeffGJ{uIdx}) ...
                           / sqrt(length(allCorrCoeffGJ{uIdx})-1);

  % This voltage has been convoluted by gauss clock with std 5ms
  allConvCorrCoeffNC{uIdx} = convCorrCoeff(runIdxNC);
  allConvCorrCoeffGJ{uIdx} = convCorrCoeff(runIdxGJ);
  
  meanConvCorrCoeffNC(uIdx) = mean(allConvCorrCoeffNC{uIdx});
  stdeConvCorrCoeffNC(uIdx) = std(allConvCorrCoeffNC{uIdx}) ...
                           / sqrt(length(allConvCorrCoeffNC{uIdx})-1);

  meanConvCorrCoeffGJ(uIdx) = mean(allConvCorrCoeffGJ{uIdx});
  stdeConvCorrCoeffGJ(uIdx) = std(allConvCorrCoeffGJ{uIdx}) ...
                           / sqrt(length(allConvCorrCoeffGJ{uIdx})-1);
                       
                       
end

%plot(uUpFreq, avgRelFreqGJNC,'k')
%hold on
close all
figure
a(1) = errorbar(uUpFreq,avgFreqNC,-stdeFreqNC,stdeFreqNC,'k'); hold on
a(2) = errorbar(uUpFreq,avgFreqGJ,-stdeFreqGJ,stdeFreqGJ,'r'); hold on
legend(a, 'NC','GJ')
xlabel('In freq (Hz/per synapse)')
ylabel('Out freq')

figure

pA = plot(uUpFreq,meanCorrCoeffNC,'k-', ...
          uUpFreq,meanCorrCoeffGJ,'r-')
hold on

errorbar(uUpFreq,meanCorrCoeffNC,-stdeCorrCoeffNC,stdeCorrCoeffNC,'k*')
errorbar(uUpFreq,meanCorrCoeffGJ,-stdeCorrCoeffGJ,stdeCorrCoeffGJ,'r*')

legend(pA,'Unconnected','Gap junction')

xlabel('Input per synapse (Hz)', 'fontsize', 20)
ylabel('Coefficient of correlation','fontsize',20)
title('Correlation between soma potentials')

figure

pA = plot(uUpFreq,meanConvCorrCoeffNC,'k-', ...
          uUpFreq,meanConvCorrCoeffGJ,'r-')
hold on

errorbar(uUpFreq,meanConvCorrCoeffNC,-stdeConvCorrCoeffNC,stdeConvCorrCoeffNC,'k*')
errorbar(uUpFreq,meanConvCorrCoeffGJ,-stdeConvCorrCoeffGJ,stdeConvCorrCoeffGJ,'r*')

legend(pA,'Unconnected','Gap junction')

xlabel('Input per synapse (Hz)', 'fontsize', 20)
ylabel('Coefficient of correlation','fontsize',20)
title('Correlation between low pass filtered soma potentials')


figure
p = errorbar(uUpFreq,avgRelFreqGJNC,-stdeRelFreqGJNC,stdeRelFreqGJNC,'ko');
hold on
plot(uUpFreq,avgRelFreqGJNC,'k--', 'linewidth',2)

xlabel('Input per synapse (Hz)','fontsize',20)
ylabel('Normalized frequency','fontsize',20)
set(gca,'FontSize',20)

saveas(p,'FIGS/TenFS-HigherFreqLessShunting.fig','fig')


figure
p = errorbar(uUpFreq,avgFracRemoved,-stdeFracRemoved,stdeFracRemoved,'k.');
hold on
plot(uUpFreq,avgFracRemoved,'k-', 'linewidth',2)
xlabel('Input per synapse (Hz)','fontsize',20)
ylabel('Fraction of spikes removed','fontsize',20)
set(gca,'FontSize',20)
box off 
axis tight

a = axis; a(3) = 0; axis(a);

saveas(p,'FIGS/TenFS-HigherFreqLessShunting-FractionRemoved.fig','fig')
saveas(p,'FIGS/TenFS-HigherFreqLessShunting-FractionRemoved.eps','psc2')
