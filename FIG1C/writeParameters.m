function writeParameters(maxTime, numCells, masterTarget, slaveTarget, ...
    gapSource, gapDest, gapRes, outputFile, masterFile, slaveFile, ...
    pulseStart, pulseEnd, pulseCurrent, pulseLoc)

if(length(gapSource) ~= length(gapDest) | length(gapDest) ~= length(gapRes))
    disp('writeParameters: gapSource and gapDest has different lengths');
    keyboard
end
   
if(length(pulseStart) ~= length(pulseEnd) ...
    | length(pulseEnd) ~= length(pulseCurrent) ...
    | length(pulseCurrent) ~= length(pulseLoc))
    disp('writeParameters: pulseStart, pulseEnd, pulseCurrent and pulseLoc must have same length!')
    keyboard

end

fid = fopen('INDATA/parameters.txt', 'w');

fprintf(fid, '%s\n', outputFile);

fprintf(fid, '%f\n', maxTime);
fprintf(fid, '%f\n', numCells);

fprintf(fid, '%s\n', masterTarget);
fprintf(fid, '%s\n', slaveTarget);
fprintf(fid, '%s\n', masterFile);
fprintf(fid, '%s\n', slaveFile);

fprintf(fid, '%d\n', length(gapSource));

for i=1:length(gapSource)
   fprintf(fid, '%s %s %f\n', gapSource{i}, gapDest{i}, gapRes(i));
end

fprintf(fid, '%d\n', length(pulseStart));


for i=1:length(pulseStart)
   fprintf(fid, '%f %f %.12f %s\n', pulseStart(i), pulseEnd(i),  pulseCurrent(i),  pulseLoc{i});
end

fclose(fid);
