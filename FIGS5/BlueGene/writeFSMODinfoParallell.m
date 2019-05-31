function writeFSMODinfo(parFile, outputFile, maxTime, numCells, ...
                        gapSource, gapDest, gapRes, ...
                        FSpars, FSMODidx, INDATApath)

fid = fopen( ['INDATA/' parFile], 'w');

fprintf(fid, outputFile);
fprintf(fid, '\n%f\n', maxTime);
fprintf(fid, '%d\n', numCells);

% Modificiation to FS channel parameters
fprintf(fid, '%f ', FSpars); 

fprintf(fid, '\n%s\n', INDATApath);

% Write information about what gap junctions to set up
fprintf(fid, '%d\n', length(gapSource));

for i=1:length(gapSource)
   fprintf(fid, '%s %s %f\n', gapSource{i}, gapDest{i}, gapRes(i));
end

% Write which FS neurons' channel parameters to modify
fprintf(fid, '%d ', FSMODidx-1);

fclose(fid);
