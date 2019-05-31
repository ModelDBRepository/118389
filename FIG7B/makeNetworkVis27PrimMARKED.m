%
% This code visualises the network connectivity, eg. Figure 7B
%

clear all, close all, format compact

randPosFlag = 0;

% This is non-wrapped connections
%load('conMat/conMat-208302750');

% Code filters out wrapped connections
nGJ = 6 % 16; % 2 % 4 % 6

%randSeed = 213272256;
randSeed = 209766906 
load(sprintf('conMat/prim/conMat-avgNGap%d-randSeed%d.mat',nGJ,randSeed));

if(randPosFlag)
  fileName = sprintf('network-27MARKED-randPos-%d.pov',nGJ);
else
  fileName = sprintf('network-27MARKED-%d.pov',nGJ);    
end
  
fid = fopen(fileName,'w');

fprintf(fid,'#include "colors.inc"\n\n');


cameraStr = 'camera {\n  location <%.2f, %.2f, %.2f>\n  look_at <%.2f,%.2f,%.2f>\n\n}\n';
cameraCoord = [4 3 -7];
cameraTarg = [0 0 0];

fprintf(fid, cameraStr, [cameraCoord cameraTarg]);

fsBaseStr = [ '#declare FSneuron =\n' ...
              'sphere { <%.2f, %.2f, %.2f>, %.2f\n' ...
              '  pigment { color rgb<%.2f, %.2f, %.2f> }\n\n' ...
              '  finish {\n    phong 1\n  }\n}\n'];

fsBaseCoord = [0 0 -1000];
fsBaseRadie = 0.1;
%fsBaseColour = [0.8 0.4 0.4];
fsBaseColour = [1 1 1];
%fsMarkedColour = [1 1 1.4];
fsMarkedColour = [0.1 0.1 0.1];
fsMarkedRadie = 0.175;

%fsMarkedColour = [0.8 0.4 0.4];
%fsBaseColour = [1 1 1.4];
     
fprintf(fid,fsBaseStr, [fsBaseCoord fsBaseRadie fsBaseColour]);

fsMarkedStr = [ '#declare FSneuronMARKED =\n' ...
                'sphere { <%.2f, %.2f, %.2f>, %.2f\n' ...
                '  pigment { color rgb<%.2f, %.2f, %.2f> }\n\n' ...
                '  finish {\n    phong 1\n  }\n}\n'];
        
fprintf(fid,fsMarkedStr, [fsBaseCoord fsMarkedRadie fsMarkedColour]);
        

fsCon = ['object {\n' ...
         '  cylinder { <%.2f, %.2f, %.2f>, <%.2f, %.2f, %.2f>, %.2f\n' ...
         '    pigment { color rgb<%.2f, %.2f, %.2f> }\n\n' ...
         '    finish {\n      phong 1\n    }\n  }\n}\n'];

lightStr = 'light_source { <%.2f, %.2f, %.2f> color White}\n\n';

fprintf(fid, lightStr, [17 95 -35]);
fprintf(fid, lightStr, [-16 20 50]);

fprintf(fid, 'object {FSneuron}\n');

fsStr = [ 'object { FSneuron\n' ...
          '  translate <%.2f, %.2f, %.2f>\n' ...
          '}\n\n'];

  
fsStrMARKED = [ 'object { FSneuronMARKED\n' ...
                '  translate <%.2f, %.2f, %.2f>\n' ...
                '}\n\n'];

  
  
[xCoord,yCoord,zCoord] = meshgrid(-2:2,-2:2,-2:2);

% Which neurons should we mark in separate colour?

%markCoords = [-1 1  0; 0 1  0; ...
%              -1 0  0; 0 0  0; ...
%              -1 1 -1; 0 1 -1; 1 1 -1; ...
%              -1 0 -1; 0 0 -1; 1 0 -1];

markCoords = [];

for i=-1:1
  for j=-1:1
    for k=-1:1
      markCoords = [markCoords; i j k];
    end
  end
end


          
          
markedIdx = [];
for i=1:size(markCoords,1)
    markedIdx = [markedIdx find(xCoord == markCoords(i,1) ...
                              & yCoord == markCoords(i,2) ...
                              & zCoord == markCoords(i,3))];
end


if(randPosFlag) 
  xCoord = xCoord + 0.2*randn(size(xCoord)); 
  yCoord = yCoord + 0.2*randn(size(yCoord)); 
  zCoord = zCoord + 0.2*randn(size(zCoord));     
end

for i=1:length(xCoord(:))
    
  if(nnz(find(i == markedIdx)))
    fprintf(fid,fsStrMARKED,[xCoord(i) yCoord(i) zCoord(i)]-fsBaseCoord); 
  else
    fprintf(fid,fsStr,[xCoord(i) yCoord(i) zCoord(i)]-fsBaseCoord); 
  end
end

[fsCap fsBase] = find(conMat);

%fsCap = [1];
%+fsBase = [2];

for i=1:length(fsCap)
  x1 = xCoord(fsCap(i));
  y1 = yCoord(fsCap(i));
  z1 = zCoord(fsCap(i));
    
  x2 = xCoord(fsBase(i));
  y2 = yCoord(fsBase(i));
  z2 = zCoord(fsBase(i));
  
  
  if(norm([(x1 - x2) (y1 - y2) (z1 - z2)]) < 4)
    % We want to skip the wrapping GJ

    if(nnz(find(fsCap(i) == markedIdx)) & nnz(find(fsBase(i) == markedIdx)))
      fprintf(fid, fsCon, [x1 y1 z1 x2 y2 z2 ...
                           0.03, ...
                           0.2 0.2 0.2]);
      
    else
      fprintf(fid, fsCon, [x1 y1 z1 x2 y2 z2 ...
                           0.02, ...
                           0.5 0.5 0.5]);
    end
  end
end           


fclose(fid);


system(sprintf('povray -geometry 1024x768 Output_Alpha=on %s',fileName))



%%%%%%% Now make 2D connection plot for marked neurons

subConMat = full(conMat(markedIdx,markedIdx));
subConMat(find(subConMat)) = 1:length(find(subConMat));

figure
showFSnetwork(subConMat,randSeed,nGJ)
