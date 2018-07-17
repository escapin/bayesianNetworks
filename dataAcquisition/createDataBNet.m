function [ data ] = createDataBNet(database, startDate, endDate)

%  The function queries the database for collected
%  temperature,humidity,window,movement data
%
%   Parameter:
%   -database : name of database (database in 'database/until12_07_26.sqlite')
%   -startDate : initial date (earliest date: '2012-06-26 00:00:00')
%   -endDate:   final date (latest date: '2012-07-28 00:00:00')
%   Return
%     matrix of data

%database ='database/until12_07_26.sqlite';
%startDate = '2012-06-26 00:00:00';
%endDate = '2012-07-28 00:00:00';

disp('Extracting Data: Temperature Door, Humidity');
tempWindHum=syncTempSmth(database, 12, 13, startDate, endDate);
tempWindHum = deleteDuplicateSensor(tempWindHum);

disp('Extracting Data: Temperature Window');
tempWindTempDoor=syncTempSmth(database, 12, 10, startDate, endDate);
tempWindTempDoor = deleteDuplicateSensor(tempWindTempDoor);

timeline=tempWindHum(2,:);

disp('Extracting Data: Window Sensor');
window = syncWinMov(database, 2, startDate, endDate);
 
disp('Extracting Data: Movement Sensor');
movement = syncWinMov(database, 9, startDate, endDate);
 
[ kettle, waterDisp, microwave ] = queryZplug(database, startDate, endDate);

data(1,:) = matchingSensorInterval(movement, timeline);
data(2,:) = matchingSensorInterval(window, timeline);
disp('Extracting Data: Kettle');
data(3,:) = matchingZplugInterval(kettle(3,:), timeline);
disp('Extracting Data: Water Dispenser');
data(4,:) = matchingZplugInterval(waterDisp(3,:), timeline);
disp('Extracting Data: Microwave');
data(5,:) = matchingZplugInterval(microwave(3,:), timeline);
 
data(6,:) = tempWindHum(1,:);
data(7,:) = tempWindHum(3,:);
data(8,:) = tempWindTempDoor(3,:);

save('dataBNet.mat');
end
