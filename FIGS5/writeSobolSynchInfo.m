function writeSobolSynchInputInfo(parFile, outputFile, maxTime, numCells, ...
                                  gapSource, gapDest, gapRes, ...
                                  sobolPars)

fid = fopen( ['INDATA/' parFile], 'w');

fprintf(fid, outputFile);
fprintf(fid, '\n%f\n', maxTime);
fprintf(fid, '%d\n', numCells);

fprintf(fid, '%f ', sobolPars); 

fprintf(fid, '\n%d\n', length(gapSource));

for i=1:length(gapSource)
   fprintf(fid, '%s %s %f\n', gapSource{i}, gapDest{i}, gapRes(i));
end

fclose(fid);
