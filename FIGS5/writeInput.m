% writeInput('/home/nobackup/genesis.DATA/INDATA/test-%d', myData)

function writeInput(filePathMask, inputData)

[r,c] = size(inputData);

for i=1:c
    data = inputData(:,i);
    spikes = data(find(data < inf));
    
    filename = sprintf(filePathMask, i);
    fid = fopen(filename, 'w');
    fprintf(fid, '%f\n',spikes);
    fclose(fid);
end
