function writeParameters(maxTime, numCells, ...
                         gapSource, gapDest, gapRes, ...
                         outputFile)
                     
                     
%if(length(gapSource) ~= length(gapDest) | length(gapDest) ~= length(gapRes))
if(length(gapSource) ~= length(gapDest) | ...
        (length(gapDest) ~= length(gapRes)) & gapRes(1) ~= inf)
    disp('writeParameters: gapSource and gapDest has different lengths');
    keyboard
end
   

fid = fopen([pwd '/INDATA/parameters.txt'], 'w');

fprintf(fid, '%s\n', outputFile);

fprintf(fid, '%f\n', maxTime);
fprintf(fid, '%d\n', numCells);

fprintf(fid, '%d\n', length(gapSource));

for i=1:length(gapSource)
   fprintf(fid, '%s %s %f\n', gapSource{i}, gapDest{i}, gapRes(i));
end

fclose(fid);
