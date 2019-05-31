% Figure S2
%
% To run the simulation:
% runOneFSsaveAMPAGABAcond.m
%
% To generate the figures:
% plotCondFigs.m
%

clear all, close all, format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')


% First column is time, second voltage, then follows the AMPA + GABA conds

somaAMPA = 1;
primAMPA = [2:4 23:25];
secAMPA  = [5:10 26:43];
tertAMPA = [11:22 44:127];

somaGABA = 128;
primGABA = [129:131 150:152];
secGABA  = [132:137 153:170];
tertGABA = [138:149 171:254];

% Set this to the rand seed of the simulation you ran.
%randSeed = [209268456 210887174]
disp('The code will give an error if you have not set the randSeed properly')
randSeed = [213826014 209135700] % First one is corr 0, 2nd one corr 0.5

disp('Make sure you set the randSeed:s to those from your simulation')

corrRudolph = [0 0.5];
dataPath = 'UTDATA/SAVED';

for i=1:length(corrRudolph)
    
  dataFile{i} = ...
      sprintf('%s/OneFS-saveAMPAGABAcond-corrRudolph-%.2f-id%d.data', ...
              dataPath, corrRudolph(i), randSeed(i));
          
  disp(sprintf('Reading %s', dataFile{i}))     
  data{i} = load(dataFile{i});      
  
  time{i} = data{i}(:,1);
  volt{i} = data{i}(:,2);
  
  somaCondAMPA{i} = sum(data{i}(:,2+somaAMPA),2);
  primCondAMPA{i} = sum(data{i}(:,2+primAMPA),2);
  secCondAMPA{i}  = sum(data{i}(:,2+secAMPA),2);
  tertCondAMPA{i} = sum(data{i}(:,2+tertAMPA),2);
  
  somaCondGABA{i} = sum(data{i}(:,2+somaGABA),2);
  primCondGABA{i} = sum(data{i}(:,2+primGABA),2);
  secCondGABA{i}  = sum(data{i}(:,2+secGABA),2);
  tertCondGABA{i} = sum(data{i}(:,2+tertGABA),2);
end
      

tStart = 0.150; tLen = 0.250;
pIdx = find(tStart <= time{1} & time{1} <= tStart + tLen);

faceCol = [0 0 0; 0.3 0.3 0.3; 0.6 0.6 0.6; 0.9 0.9 0.9];

for i=1:length(corrRudolph)
  figure
  subplot(3,1,1);
  plot(1e3*(time{i}(pIdx)-tStart),1e3*volt{i}(pIdx),'k','linewidth',2)
%  xlabel('Time (ms)','fontsize',24)
  ylabel('Volt (mV)','fontsize',24)
  set(gca,'fontsize',18)
  set(gca,'ytick',[-50 0])
  box off
  t1 = title(sprintf('Correlation = %.1f', corrRudolph(i)),'fontsize',26);
  a = axis; a(1) = 0; a(2) = tLen*1e3; a(3) = -80; a(4) = 40; axis(a);
  pw = get(gca,'position'); pw(3) = 0.6; set(gca,'position',pw);
  
  subplot(3,1,2);
  p = area(1e3*(time{i}(pIdx)-tStart),[somaCondAMPA{i}(pIdx) ...
                                       primCondAMPA{i}(pIdx) ...
                                       secCondAMPA{i}(pIdx) ...
                                       tertCondAMPA{i}(pIdx)]*1e9);

  for j=1:length(p)
    set(p(j),'facecolor',faceCol(j,:))
  end
                               
  %xlabel('Time (ms)','fontsize',24)
  ylabel('Cond (nS)','fontsize',24)
  set(gca,'fontsize',18)
  box off
  a = axis; a(1) = 0; a(2) = tLen*1e3; a(4) = 10; axis(a);
  pw = get(gca,'position'); pw(3) = 0.6; set(gca,'position',pw);
    
  leg = legend(p,'soma','prim','sec','tert','location','best');
  set(leg,'position',get(leg,'position') + [0.3 0 0 0])
  t2 = title('AMPA','fontsize',26);
  set(t2,'position',[125 7 1.0001])
  
  subplot(3,1,3);
  p = area(1e3*(time{i}(pIdx)-tStart),[somaCondGABA{i}(pIdx) ...
                                       primCondGABA{i}(pIdx) ...
                                       secCondGABA{i}(pIdx) ...
                                       tertCondGABA{i}(pIdx)]*1e9);
                               
  for j=1:length(p)
    set(p(j),'facecolor',faceCol(j,:))
  end
                               
  xlabel('Time (ms)','fontsize',24)
  ylabel('Cond (nS)','fontsize',24)
  set(gca,'fontsize',18)
  box off
  a = axis; a(1) = 0; a(2) = tLen*1e3; a(4) = 10; axis(a);
  pw = get(gca,'position'); pw(3) = 0.6; set(gca,'position',pw);

  %legend(p,'soma','prim','sec','tert')
  t3 = title('GABA','fontsize',26);
  set(t3,'position',[125 7 1.0001])
  
  figFile = strrep(dataFile{i},'UTDATA/SAVED','FIGS');
  figFile = strrep(figFile,'.data','.fig');
  saveas(gcf,figFile,'fig');
  saveas(gcf,strrep(figFile,'.fig','.eps'),'psc2');
  
end


