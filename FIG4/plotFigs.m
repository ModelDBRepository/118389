function p = plotFigs(dataNC,dataGJ)

  figure
  pA = plot(dataNC(:,1)*1e3-120,dataNC(:,2)*1e3,'k', ...
            dataNC(:,1)*1e3-120, dataNC(:,3)*1e3,'r','linewidth',2);
  xlabel('Time (ms)','fontsize',20)
  ylabel('Voltage (mV)','fontsize',20)
  title('Reference','fontsize',24)
  box off
  axis([0 200 -80 -20])
  set(gca,'FontSize',20)
  
  figure
  pB = plot(dataGJ(:,1)*1e3-120, dataGJ(:,2)*1e3,'k',  ...
            dataGJ(:,1)*1e3-120, dataGJ(:,3)*1e3,'r','linewidth',2);
  xlabel('Time (ms)','fontsize',20)
  ylabel('Voltage (mV)','fontsize',20)
  title('With electrical synapse','fontsize',24) 
  box off
  axis([0 200 -80 -20])
  set(gca,'FontSize',20)
  
  p = [pA(1) pB(1)];
  
end
