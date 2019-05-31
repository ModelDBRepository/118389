% [gapSrc, gapDest, conMat] = makeFSrandomNetwork(numFS, numGJ)
%
% This function generates the random GJ connections for a FS network
% numFS is the number of FS connections
% FSidx is the index of the FS neurons to connect, eg. 0:2:20
% numGJ is the number of GJ per FS
%
% Use showFSnetwork(conMat) to visualize connections.

function [gapSrc, gapDest, conMat] = makeFSrandomNetwork(FSidx, numGJ)

if(length(FSidx) == 1)
  disp('makeFSrandomNetwork has changed, now requires index of neurons')
  FSidx = (1:FSidx)-1;
end
  
numFS = length(FSidx);

validMatrix = 0;
randCtr = 0;

while(~validMatrix && randCtr < 100) 

  conMat = zeros(numFS,numFS);
  validCons = ones(numFS,numFS);
  validCons = validCons - diag(diag(validCons));

  conNum = 1;

  while(nnz(validCons) > 0)
    validId = find(validCons);
    id = ceil(length(validId)*rand);
  
    conMat(validId(id)) = conNum;
    validCons(validId(id)) = 0;
  
    [y,x] = find(conMat == conNum);

    % Connections are symmetrical
    conMat(x,y) = conNum;
    validCons(x,y) = 0;
  
  
    % Take away the connections that are no longer possible
    % No diagonal elements
    % Row sum must be numGJ, same with column sum

    if(nnz(conMat(:,y)) >= numGJ)
       validCons(:,y) = 0; 
    end

    if(nnz(conMat(:,x)) >= numGJ)
      validCons(:,x) = 0; 
    end

    if(nnz(conMat(x,:)) >= numGJ)
      validCons(x,:) = 0;
    end

    if(nnz(conMat(y,:)) >= numGJ)
      validCons(y,:) = 0;
    end
  
    conNum = conNum + 1;
  
    % conMat
    % validCons
    % keyboard
  
  end

  if(nnz(conMat) == numFS*numGJ)
    validMatrix = 1; 
  else
    randCtr = randCtr + 1;  
  end

end  

if(nnz(conMat) ~= numFS*numGJ)
  disp(['Warning, should have ' num2str(numFS*numGJ) ' connections ' ...
        'but only have ' num2str(nnz(conMat))])    
  keyboard
end

GJctr = zeros(numFS,1);

for i=1:max(conMat(:))
  % Symmetric matrix, since GJ are two way connections
  [x,y] = find(conMat == i);
  
  x = x(1);
  y = y(1);
  
  % We number the neurons 1 to n in matlab, but genesis uses 0 to (n-1)
  %gapSrc{i} = ['/fs[' num2str(x-1) ']/primdend' num2str(GJctr(x)+1)];
  %gapDest{i} = ['/fs[' num2str(y-1) ']/primdend' num2str(GJctr(y)+1)];
  gapSrc{i} = ['/fs[' num2str(FSidx(x)) ']/primdend' num2str(GJctr(x)+1)];
  gapDest{i} = ['/fs[' num2str(FSidx(y)) ']/primdend' num2str(GJctr(y)+1)];
  
  GJctr(x) = mod(GJctr(x),3)+1;
  GJctr(y) = mod(GJctr(y),3)+1;
  
end

