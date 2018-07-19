function dataZplug = createDataZplug

load('matrices/dataBNet_12_06_26__12_07_28.mat', 'data', 'maxZplug');

% movement
dataZplug(1,:)=data(1,:);
% presence
dataZplug(2,:)=cell(1,size(data,2));
% window
dataZplug(3,:)=data(2,:);
% zPlug
dataZplug(4,:)=maxZplug;
% temp - hum
dataZplug(5:7,:)=data(6:8,:);