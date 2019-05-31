% This function generates a connection matrix for the FS neurons

function [gapSrc, gapDest, conMat] = makeFSconnectionMatrixOnlySecWrappedSetNGJ(nX,nY,nZ,nGJ)

nTot = nX*nY*nZ;

if(nGJ == 0)
   gapSrc = [];
   gapDest = [];
   conMat = sparse(nTot,nTot);

   return
end

plotFlag = 0;

%clear all, close all

avgDist = 150e-6;

lenX = nX*avgDist;
lenY = nY*avgDist;
lenZ = nZ*avgDist;

[xCoord,yCoord,zCoord] = ...
    meshgrid((1:nX)*avgDist,(1:nY)*avgDist,(1:nZ)*avgDist);

xdist = abs(repmat(xCoord(:),1,nTot) - repmat(xCoord(:)',nTot,1));
ydist = abs(repmat(yCoord(:),1,nTot) - repmat(yCoord(:)',nTot,1));
zdist = abs(repmat(zCoord(:),1,nTot) - repmat(zCoord(:)',nTot,1));

xdist = min(xdist, lenX-xdist);
ydist = min(ydist, lenY-ydist);
zdist = min(zdist, lenZ-zdist);

distMat = sqrt(xdist.^2 + ydist.^2 + zdist.^2);

% With the current implementation we just want to set diagonal to zero
% not the entire lower triangular
distMat(find(diag(diag(distMat)))) = inf;

% Setting R = 100e-6 for primary dendrite gap junctions           
% R = 248e-6 for secondary denrites...
R = 150e-6; %100e-6; %248e-6;

distMask = (0 < distMat & distMat <= 2*R);

% Volume of intersection between two identical spheres
% http://mathworld.wolfram.com/Sphere-SphereIntersection.html

Vint = (pi/12) * (4*R + distMat).*(2*R - distMat).^2;
Vint(~distMask) = 0;

% We want to specify how many gap junctions the neurons
% should have on average, then have them distributed randomly, based
% on the overlapping volumes.
%

avgNumCons = nGJ; 

% Calculate the cumulative probability distribution
Vprob = cumsum(Vint,2);
VprobN = repmat(Vprob(:,end),1,size(Vprob,2));
Vprob = Vprob./VprobN;

connectionList = [];

connectionMask = zeros(size(Vprob));

for i=1:ceil(avgNumCons/2)
  % We should place avgNumCons gap junctions on each neuron (on average)
  % since gap junctions are connections between two neurons, we only
  % need to add avgNumCons/2.
  
  for j=1:size(Vprob,1)
    idx = find(rand < Vprob(j,:),1);

    connectionList = [connectionList; j, idx];
    connectionMask(j,idx) = connectionMask(j,idx) + 1;
  end
end


conMat = sparse(connectionMask);
clear connectionMask

%keyboard
%spy(connectionMask)


primGJloc{1} = 'primdend1';
primGJloc{2} = 'primdend2';
primGJloc{3} = 'primdend3';

secGJloc{1}  = 'secdend1';
secGJloc{2}  = 'secdend1/sec_dend2';
secGJloc{3}  = 'secdend1/sec_dend3';
secGJloc{4}  = 'secdend1/sec_dend4';
secGJloc{5}  = 'secdend2';
secGJloc{6}  = 'secdend2/sec_dend2';
secGJloc{7}  = 'secdend2/sec_dend3';
secGJloc{8}  = 'secdend2/sec_dend4';
secGJloc{9}  = 'secdend3';
secGJloc{10} = 'secdend3/sec_dend2';
secGJloc{11} = 'secdend3/sec_dend3';
secGJloc{12} = 'secdend3/sec_dend4';
secGJloc{13} = 'secdend4';
secGJloc{14} = 'secdend4/sec_dend2';
secGJloc{15} = 'secdend4/sec_dend3';
secGJloc{16} = 'secdend4/sec_dend4';
secGJloc{17} = 'secdend5';
secGJloc{18} = 'secdend5/sec_dend2';
secGJloc{19} = 'secdend5/sec_dend3';
secGJloc{20} = 'secdend5/sec_dend4';
secGJloc{21} = 'secdend6';
secGJloc{22} = 'secdend6/sec_dend2';
secGJloc{23} = 'secdend6/sec_dend3';
secGJloc{24} = 'secdend6/sec_dend4';

innerSecGJloc{1}  = 'secdend1';
innerSecGJloc{2}  = 'secdend2';
innerSecGJloc{3}  = 'secdend3';
innerSecGJloc{4}  = 'secdend4';
innerSecGJloc{5}  = 'secdend5';
innerSecGJloc{6}  = 'secdend6';


% Are the neurons within 2x the prim dendrite distance?
% maxPrimDist = 2*100e-6;


%[srcIdx,destIdx] = find(connectionMask);
srcIdx = connectionList(:,1);
destIdx = connectionList(:,2);

clear connectionMask

for i=1:length(srcIdx)
    
%  % If the neurons are close to each other connect to primary dendrite
%  % otherwise connect on secondary dendrite.
%  if(distMat(srcIdx(i),destIdx(i)) <= maxPrimDist)
%    dendLocSrc = primGJloc{ceil(rand*length(primGJloc))};
%    dendLocDest = primGJloc{ceil(rand*length(primGJloc))};
%  else
%    disp('Using secondary dendrites, this is OnlyPrim file...')
%    keyboard
%    
%    dendLocSrc = secGJloc{ceil(rand*length(secGJloc))};
%    dendLocDest = secGJloc{ceil(rand*length(secGJloc))};
%  end
   
  dendLocSrc = innerSecGJloc{ceil(rand*length(innerSecGJloc))};
  dendLocDest = innerSecGJloc{ceil(rand*length(innerSecGJloc))};  
  
  gapSrc{i} = sprintf('/fs[%d]/%s',srcIdx(i)-1,dendLocSrc);
  gapDest{i} = sprintf('/fs[%d]/%s',destIdx(i)-1,dendLocDest);
end
    
%keyboard

clear distMat

if(plotFlag)
  plot3dConMatSimple(conMat,xCoord,yCoord,zCoord)
end
