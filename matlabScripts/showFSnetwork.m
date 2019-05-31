% Visualises a random FS network's GJ connections

function showFSnetwork(conMat, randSeed)

[r,c] = size(conMat);

if(r ~= c)
  disp('Not a square connection matrix')
  keyboard
end

numFS = r;



theta = pi/2 + linspace(2*pi,0, numFS+1);
theta(end) = [];

x = cos(theta);
y = sin(theta);

clf, hold on

for i=1:max(conMat(:))
  [src,dest] = find(conMat == i);

  src = src(1);
  dest = dest(1);
 
  p = plot([x(src) x(dest)], [y(src) y(dest)], 'k'); hold on
  set(p, 'LineWidth', 2)
  
end

p = plot(x,y,'ok'); 
axis off, axis equal
set(p, 'Markersize',30, ...
       'MarkerEdgeColor', [0 0 0], ...
       'MarkerFaceColor', [1 0 0], ...
       'LineWidth', 2)

axis(axis*1.1)   

tcx = 2.9e-2;
tcy = 2.9e-2;

for i = 1:length(x)
  pt = text(x(i)-tcx*length(num2str(i)),y(i)-tcy, num2str(i));
  set(pt,'FontSize', 15);
end

saveas(p, ['FIGS/FS-network-' num2str(randSeed) '.fig'], 'fig')
