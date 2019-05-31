function writeCurrentInputInfo(curStart, curEnd, curAmp, curLoc)

nCurs = length(curStart)

path = [pwd '/INDATA/'];

fid = fopen([path 'currentInputInfo.txt'], 'w');

fprintf(fid, '%d\n', nCurs);

for i=1:nCurs
    
    fprintf(fid, '%f\n', curStart{i});
    fprintf(fid, '%f\n', curEnd{i});
    fprintf(fid, '%d\n', curAmp{i});
    fprintf(fid, '%s\n', curLoc{i});
    
end

fclose(fid);
