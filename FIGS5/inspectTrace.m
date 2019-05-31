function inspectTrace(data)

figure
s(1) = subplot(2,1,1);
plot(data(:,1),data(:,2:2:21)) 

s(2) = subplot(2,1,2);
plot(data(:,1),data(:,3:2:21)) 

linkaxes(s,'x')
