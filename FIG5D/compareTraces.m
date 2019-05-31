% This function reads in two files, one with GJ connected data and
% then the unconnected reference trace. Then it plots the two voltage
% traces in two subplots and locks the axes so when one of the plots
% is moved or zoomed the other one follows.
%
% To generate data, run runTenFScurInjectHomogeneNetworkGJonoff.m
%
%
% When asked for a file, input:
% 
% 'UTDATA/SAVED/TenHomoFSGJonoffCurInject/TenHomoFS-prim-CurInject-GJonoff-id210991775-gapres-2000000compareTraces'
% 
% Obs, you might have to replace the randomId in idXXXXXXXXXX with your number.


close all, format compact

% Matlab helper scripts are located here
path(path,'../matlabScripts')



if(~exist('filenameGJ'))

  % Ask for the connected simulation run
  filenameGJ = input('Please input GJ data-file to read: ');    

  % Figure out the filename of the reference run
  GJresStr = regexp(filenameGJ, 'gapres-[0-9]+','match');
  filenameRef = strrep(filenameGJ, GJresStr, 'gapres-Inf');
  filenameRef = char(strrep(filenameRef, 'prim', 'nonConRef'));

  % Get random seed
  randSeedStr = regexp(filenameGJ,'id[0-9]+','match');
  filePath = filenameGJ(1:find(filenameGJ == '/', 1, 'last'));

  % Load connection matrix
  randSeedStr = randSeedStr{1}([3:end]);
  filenameConMat = [filePath 'conMat-' randSeedStr '.mat'];
  randSeed = num2str(randSeedStr);
  
  % Clean up GJresStr, used in plot later
  GJres = regexp(GJresStr, '[0-9]+','match');
  GJcond = 1/str2num(GJres{1}{1});

  disp(['Loading ' filenameGJ])
  dataGJ = load(filenameGJ);

  disp(['Loading ' filenameRef])
  dataRef = load(filenameRef);

  disp(['Loading ' filenameConMat])
  load(filenameConMat)

end  

% Display the network for easy selection of neurons
figure
showFSnetwork(conMat, randSeed)

conMatMod = conMat + diag(diag(ones(size(conMat))));

numCells = size(dataGJ,2)-1;

% Ask what traces to show
trace = input(['Select neurons to view (1 - ' ...
                num2str(numCells) '), ' ...
                'no input means all traces: ' ]);

if(length(trace) == 1)
  askNeighbour = trace;
  trace = [];
  
  while(length(askNeighbour) > 0)
  
    trace = [trace askNeighbour];
  
    disp(['Currently selected neurons ' num2str(trace)])
    
    neurons = zeros(numCells,1);
    neurons(trace) = 1;
    
    % Which neurons are connected to our selected neurons in one step
    reachMat = conMatMod * neurons;
    
    neighbourNeurons = setdiff(find(reachMat'), trace);
    
    if(length(neighbourNeurons > 0))
    
      disp(['Available neighbours ' num2str(neighbourNeurons)])
      disp('Do you want to select a connected neighbour?')
    
      askNeighbour = input('Select neuron (return ends process): ');
  
    else
      askNeighbour = [];
    end
  
    trace = unique(trace);
  end  
    
      

end
        
if(length(trace) == 0)
  trace = 1:numCells;
end

if(length(trace) > 1)
  subMat = conMatMod(trace,trace);
  subMatClique = subMat^length(trace);
  
  if(min(subMatClique) < 1)
    disp('WARNING: The selection of neurons are not all in one clique') 
    disp('There are atleast two neuron that there is no GJ path between')
  end
end

figure
showFSnetworkMark(conMat, randSeed, trace)

figure
pHand(1) = subplot(2,1,1);
plot(dataGJ(:,1), dataGJ(:,trace+1))
xlabel('Time (s)')
ylabel('Voltage (V)')
title(['Gap junction connected ' num2str(GJcond*1e9) 'nS'])

pHand(2) = subplot(2,1,2);
p = plot(dataRef(:,1), dataRef(:,trace+1));
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Nonconnected reference')

for i=1:length(p)
  pLeg{i} = ['Neuron ' num2str(trace(i))]; 
end
legend(p, pLeg, 'Location', 'Best')

linkprop(pHand,'View');
linkprop(pHand,'Ylim');
linkprop(pHand,'Xlim');
% linkprop(pHand,'Zlim');

a = axis;

saveas(p(1), ['FIGS/TenFS/FS-exampleTrace-' num2str(randSeed) '.fig'], 'fig')
