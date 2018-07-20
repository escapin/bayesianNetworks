function dataZplug = createBnetZplug(bNet, maxZplug)

%load('../data/dataBNet_12_06_26__12_07_28.mat', 'data', 'maxZplug');

% movement
dataZplug(1,:)=bNet(1,:);
% presence
dataZplug(2,:)=cell(1,size(bNet,2));
% windowOpen sensor
dataZplug(3,:)=bNet(2,:);
% zPlug sensor
dataZplug(4,:)=maxZplug;
% temperatureWindow - relativeHumidity level - temeratureDoor
dataZplug(5:7,:)=bNet(6:8,:);

end