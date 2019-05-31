%format compact

function makeAllExternalInputAllUpstate(corrRudolph, upFreq, noiseFreq, ...
                                        maxTime, allowVar, randSeed, numCells)

rand('seed', randSeed)
randSeed = rand('seed');

disp(['Setting random seed to ' num2str(randSeed)])
                   

path = [pwd '/INDATA/'];

% allowVar = 1 --> mother/daughter generation
% allowVar = 0 --> fixed number of doubletts for all spikes train-version

% allowVar = 1

nAMPA = 127;
nGABA = 93;

% corrRudolph = 0.5;
% upFreq = 20/9;
downFreq = 1e-9;
gammaShape = 3;      % gives shape of probability distribution
% maxTime = 50;
% noiseFreq = 0.2;

disp('Bör fundera på om bruset ska vara korrelerat mellan cellerna eller inte')
%keyboard

for nCtr = 1:numCells

    if(allowVar)
        disp('Generating mother/daughter input')
    
        insignalAMPA = makeDaughterNoise(corrRudolph, nAMPA, ...
                                         upFreq, maxTime);

        insignalGABA = makeDaughterNoise(corrRudolph, nGABA, ...
                                         upFreq, maxTime);
                                  
        noiseAMPA = makeDaughterNoise(corrRudolph, nAMPA, noiseFreq, maxTime);
        noiseGABA = makeDaughterNoise(corrRudolph, nGABA, noiseFreq, maxTime);
    
    else                                  
        disp('Generating input with constant number of doubletts')  
        insignalAMPA = makeTrainNoise(corrRudolph, nAMPA, ...
                                      upFreq, maxTime);

        insignalGABA = makeTrainNoise(corrRudolph, nGABA, ...
                                      upFreq, maxTime);
                                      
        noiseAMPA = makeTrainNoise(corrRudolph, nAMPA, noiseFreq, maxTime);
        noiseGABA = makeTrainNoise(corrRudolph, nGABA, noiseFreq, maxTime);
    end
    
    % Pad at the end with a large number, this is to make sure that
    % no spike trains are empty!
    insignalAMPA = [insignalAMPA; 1e5*maxTime*ones(1,nAMPA)];
    insignalGABA = [insignalGABA; 1e5*maxTime*ones(1,nGABA)];
    noiseAMPA = [noiseAMPA; 1e5*maxTime*ones(1,nAMPA)];
    noiseGABA = [noiseGABA; 1e5*maxTime*ones(1,nGABA)];
    
%    keyboard
    
    writeInput([path 'AMPAinsignal_' num2str(nCtr) '_%d'], insignalAMPA);
    writeInput([path 'GABAinsignal_' num2str(nCtr) '_%d'], insignalGABA);

    writeInput([path 'AMPAnoise_' num2str(nCtr) '_%d'], noiseAMPA);
    writeInput([path 'GABAnoise_' num2str(nCtr) '_%d'], noiseGABA);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen([path 'inputInfo.txt'], 'w');

fprintf(fid, '%s\n', 'All upstate input');
fprintf(fid, '%f\n', corrRudolph);
fprintf(fid, '%f\n', upFreq);
fprintf(fid, '%f\n', noiseFreq);
fprintf(fid, '%f\n', maxTime);
fprintf(fid, '%d\n', allowVar);
fprintf(fid, '%d\n', randSeed);
fprintf(fid, '%d\n', numCells);
% fprintf(fid, '%d\n', gammaShape);

fclose(fid);
