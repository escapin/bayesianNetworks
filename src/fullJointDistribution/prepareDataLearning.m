function [data, minmaxVector] = prepareDataLearning(data)


movement=1;
presence=2; % hidden
window=3;
zPlug=4;
tempWin=5;
humidity=6;
tempDoor=7;

granZplug=0;
gran=1;

% Zplug
vector=round(cell2num(data(zPlug,:))*(10^granZplug));
minmaxVector(1,1)=min(vector);
minmaxVector(2,1)=max(vector);
data(zPlug,:)=num2cell(vector(1,:)/(10^granZplug));

% Temperature Window
vector=round(cellfun(@str2num, data(tempWin,:))*(10^gran));
minmaxVector(1,2)=min(vector);
minmaxVector(2,2)=max(vector);
data(tempWin,:)=num2cell(vector(1,:)/(10^gran));

% Humidity
vector=round(cellfun(@str2num, data(humidity,:))*(10^gran));
minmaxVector(1,3)=min(vector);
minmaxVector(2,3)=max(vector);
data(humidity,:)=num2cell(vector(1,:)/(10^gran));

% Temperature Door
vector=round(cellfun(@str2num, data(tempDoor,:))*(10^gran));
minmaxVector(1,4)=min(vector);
minmaxVector(2,4)=max(vector);
data(tempDoor,:)=num2cell(vector(1,:)/(10^gran));


% fit the data from 1 to node_size

% movement and window
tmp=cell2num(data([movement window],:));
tmp(tmp==1)=2;
tmp(tmp==0)=1;
data([movement window],:)=num2cell(tmp);

% zPlug
tmp=cell2num(data(zPlug,:));
tmp=tmp*(10^granZplug);
tmp=tmp-minmaxVector(1,1)+1;
data(zPlug,:)=num2cell(tmp);

% temperature humidity
tmp=cell2num(data([tempWin:tempDoor],:));
tmp=tmp*(10^gran);
tmp(1,:)=tmp(1,:)-minmaxVector(1,2)+1;
tmp(2,:)=tmp(2,:)-minmaxVector(1,3)+1;
tmp(3,:)=tmp(3,:)-minmaxVector(1,4)+1;

data(tempWin,:)=num2cell(tmp(1,:));
data(humidity,:)=num2cell(tmp(2,:));
data(tempDoor,:)=num2cell(tmp(3,:));


