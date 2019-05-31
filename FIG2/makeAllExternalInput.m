%format compact

function makeAllExternalInput(corrRudolph, upFreq, noiseFreq, ...
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
% maxTime = 50;
% noiseFreq = 0.2;

disp('Bör fundera på om bruset ska vara korrelerat mellan cellerna eller inte')
%keyboard

for nCtr = 1:numCells

    if(allowVar)
        disp('Generating mother/daughter input')
    
        insignalAMPA = makeDaughterInsignal(corrRudolph, nAMPA, ...
                                             upFreq, downFreq, maxTime);

        insignalGABA = makeDaughterInsignal(corrRudolph, nGABA, ...
                                            upFreq, downFreq, maxTime);
                                  
        noiseAMPA = makeDaughterNoise(corrRudolph, nAMPA, noiseFreq, maxTime);
        noiseGABA = makeDaughterNoise(corrRudolph, nGABA, noiseFreq, maxTime);
    
    else                                  
        disp('Generating input with constant number of doubletts')  
        insignalAMPA = makeTrainInsignal(corrRudolph, nAMPA, ...
                                         upFreq, downFreq, maxTime);

        insignalGABA = makeTrainInsignal(corrRudolph, nGABA, ...
                                         upFreq, downFreq, maxTime);
                                      
        noiseAMPA = makeTrainNoise(corrRudolph, nAMPA, noiseFreq, maxTime);
        noiseGABA = makeTrainNoise(corrRudolph, nGABA, noiseFreq, maxTime);
    end
    
%    keyboard
    
    writeInput([path 'AMPAinsignal_' num2str(nCtr) '_%d'], insignalAMPA);
    writeInput([path 'GABAinsignal_' num2str(nCtr) '_%d'], insignalGABA);

    writeInput([path 'AMPAnoise_' num2str(nCtr) '_%d'], noiseAMPA);
    writeInput([path 'GABAnoise_' num2str(nCtr) '_%d'], noiseGABA);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen([path 'inputInfo.txt'], 'w');

fprintf(fid, '%s\n', 'Upstate/downstate insignal only');
fprintf(fid, '%f\n', corrRudolph);
fprintf(fid, '%f\n', upFreq);
fprintf(fid, '%f\n', noiseFreq);
fprintf(fid, '%f\n', maxTime);
fprintf(fid, '%d\n', allowVar);
fprintf(fid, '%d\n', randSeed);
fprintf(fid, '%d\n', numCells);

fclose(fid);
