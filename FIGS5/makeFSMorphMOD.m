%
% OBS kolla nu så att rand-längderna sätts rätt på de olika compartments
%
% FUNDERING: Antingen förstorar jag alla tert-dend kompartments lika
% och då ska inte varje sub-kompartment få olika storlek, ty det är
% bara en numerisk behandling... har inget med morphologin att göra
% eller så ska jag slumpa alla compartments oberoende av varandra
% för att bryta symmetrin...
%
% Tror i första approx att jag bara förstorar alla tert-dends.





% Generates nCells number of p-files for the FSMorphology

% maxVar = variation, ie 0.10 = 10% (randomized)
% channelsVar = name of channels to vary, in a cell-matrix
% compLenVar = variation of compartment length

function makeFSMorphMOD(cellIdx, maxVar, channelsVar, compLenVar)


path = [pwd '/INDATA/'];
fnMask = 'FSmorph-%d.p';

compParam{1} = 'ELEAK';     compValue(1) = -0.063;
compParam{2} = 'RA';        compValue(2) = 3;
compParam{3} = 'RM';        compValue(3) = 2;
compParam{4} = 'CM';        compValue(4) = 0.007;
compParam{5} = 'EREST_ACT'; compValue(5) = -0.063;

tertChanName = {'AMPA_channel', 'GABA_channel'};
tertChanCondBase = [16, 24];

secChanName  = {'AMPA_channel', 'GABA_channel'};
secChanCondBase  = [8.65, 13];

primChanName = {'AMPA_channel', 'GABA_channel', 'A_channel_MOD'};
primChanCondBase = [5.333, 8.0, 90];

somaChanName = {'Na_channel_MOD', 'K3132_channel_MOD', 'A_channel_MOD', ...
               'K13_channel_MOD', 'AMPA_channel', 'GABA_channel'};
somaChanCondBase = [1149, 582, 333, 1.46, 0.8, 1.2];


somaChanMask = zeros(size(somaChanCondBase));
primChanMask = zeros(size(primChanCondBase));
secChanMask  = zeros(size(secChanCondBase));
tertChanMask = zeros(size(tertChanCondBase));

for i=1:length(channelsVar)
  somaChanMask = somaChanMask | strcmp(somaChanName, channelsVar{i});
  primChanMask = primChanMask | strcmp(primChanName, channelsVar{i});
  secChanMask  = secChanMask  | strcmp(secChanName,  channelsVar{i});
  tertChanMask = tertChanMask | strcmp(tertChanName, channelsVar{i});    
end

% Just a error check...
for i=1:length(channelsVar)
  if(sum(strcmp(somaChanName, channelsVar{i})) ...
     | sum(strcmp(primChanName, channelsVar{i})) ...
     | sum(strcmp(secChanName,  channelsVar{i})) ...
     | sum(strcmp(tertChanName, channelsVar{i})))
    disp(['Varying channel ' channelsVar{i} ' by ' ...
           num2str(maxVar*100) '%'])
          
  else
    disp(['Warning, no channel ' channelsVar{i} ...
          ' found, did you spell it right?'])
    disp('Type return to continue')
  
    keyboard
  end
end

%%%%% Length variation

disp(['Varying length by ' num2str(compLenVar*100) ' %'])

tertLen = 30;
secLen = 37;
primLen = 45;
somaLen = 20;


for iCell = cellIdx %1:nCells
    
  libName = ['cell' num2str(iCell)];

  % Varje cell får sin egen slumpade uppsättning
    
%  keyboard
  
  tertChanCond = tertChanCondBase ...
                .* (1 + tertChanMask*maxVar.*(1-2*rand(size(tertChanCondBase))));
  secChanCond  = secChanCondBase ... 
                .* (1 + secChanMask*maxVar.*(1-2*rand(size(secChanCondBase))));
  primChanCond = primChanCondBase ...
                .* (1 + primChanMask*maxVar.*(1-2*rand(size(primChanCondBase))));
  somaChanCond = somaChanCondBase ...
                .* (1 + somaChanMask*maxVar.*(1-2*rand(size(somaChanCondBase)))); 


  tLen = tertLen*(1 + compLenVar*(1-2*rand));  
  sLen = secLen*(1 + compLenVar*(1-2*rand)); 
  pLen = primLen*(1 + compLenVar*(1-2*rand)); 
  soLen = somaLen*(1 + compLenVar*(1-2*rand));   
            
            
  fn = sprintf(fnMask, iCell);
  fid = fopen([path fn], 'w');
  
  fprintf(fid, '*relative\n*cartesian\n*asymmetric\n*lambda_warn\n\n');

  for j=1:length(compParam)
    fprintf(fid, '*set_compt_param %s %f \n', compParam{j}, compValue(j));
  end
  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Creating templates for compartments

  compNum{1} = '';
  parentName{1} = 'none';

  for i=2:8
   compNum{i} = num2str(i);
   parentName{i} = '.';
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Tertiary dendrites  
  
  fprintf(fid, ['\n*start_cell /library/' libName '/tert_dend\n']);

  for i=1:8
      
    fprintf(fid, ['\ntert_dend' compNum{i} ' ' parentName{i} ...
                  ' ' num2str(tLen) ' 0 0 0.5 ']);
         
    for j=1:length(tertChanName)
        fprintf(fid, '%s %d ', tertChanName{j}, tertChanCond(j));
    end
  end

  fprintf(fid,['\n*makeproto /library/' libName '/tert_dend\n\n']);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Secondary dendrites
  
  fprintf(fid, ['*start_cell /library/' libName '/sec_dend\n']);

  for i=1:4
      
     fprintf(fid, ['\nsec_dend' compNum{i} ' ' parentName{i} ...
                   ' ' num2str(sLen) ' 0 0 0.75 ']);
     for j=1:length(secChanName)
         fprintf(fid, '%s %d ', secChanName{j}, secChanCond(j));
     end
  end

  fprintf(fid, ['\n*makeproto /library/' libName '/sec_dend\n\n']);

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Primary dendrites
  
  
  fprintf(fid, ['*start_cell /library/' libName '/prim_dend\n']);

  for i=1:2
   
   fprintf(fid, ['\nprim_dend' compNum{i} ' ' parentName{i} ...
                 ' ' num2str(pLen) ' 0 0 1 ']);
   for j=1:length(primChanName)
       fprintf(fid, '%s %d ', primChanName{j}, primChanCond(j));
   end
  end

  fprintf(fid, ['\n*makeproto /library/' libName '/prim_dend\n\n']);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Soma
  
  fprintf(fid, '*start_cell\n');

  
  fprintf(fid, ['soma none ' num2str(soLen) ' 0 0 15 ']);

  
  for j=1:length(somaChanName)
    fprintf(fid, '%s %d ', somaChanName{j}, somaChanCond(j));
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Create morphology
  
  fprintf(fid, ['\n\n*compt /library/' libName '/prim_dend\n']);

  for j=1:3
    fprintf(fid, ['primdend' num2str(j) ' soma ' num2str(pLen) ' 0 0 1\n']);
  end

  
  fprintf(fid, ['\n*compt /library/' libName '/sec_dend\n']);

  for j=1:6
    fprintf(fid, ['secdend' num2str(j) ...
                  ' primdend' num2str(floor((j+1)/2)) '/prim_dend2' ...
                  ' ' num2str(sLen) ' 0 0 0.75\n']);
  end

  
  fprintf(fid, ['\n*compt /library/' libName '/tert_dend\n']);

  for j=1:12
    fprintf(fid, ['tertdend' num2str(j) ...
                  ' secdend' num2str(floor((j+1)/2)) '/sec_dend4' ...
                  ' ' num2str(tLen) '  0  0  0.5\n']);
  end

  fclose(fid); 
  
end
