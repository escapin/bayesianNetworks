function [ Bnet, timeline] = computeBnet(database, startDate, endDate)

%  The function queries the database for collected
%  temperature,humidity,window,movement data
%
%   Parameter:
%   -database : name of database (database in 'database/until12_07_26.sqlite')
%   -startDate : initial date (earliest date: '2012-06-26 00:00:00')
%   -endDate:   final date (latest date: '2012-07-28 00:00:00')
%   Return:
%   -  [8x#samples] matrix representing the Bayesian Network
%   -  timeline: the timeline of timestamps

%database ='database/until12_07_26.sqlite';
%startDate = '2012-06-26 00:00:00';
%endDate = '2012-07-28 00:00:00';

disp('------------------------------------------------------------------------------------');
% EXTRACTING DATA
disp("[ 1/10] Extracting data from the 'WindowsOpen' sensor: when the window is open.");
windowOpen = extractWhenSensorOn(database, 2, startDate, endDate);
  
disp("[ 2/10] Extracting data from the 'Movement' sensor: when a movement is detected.");
movement = extractWhenSensorOn(database, 9, startDate, endDate);

disp("[ 3/10] Extracting data from the 'Z-Plug' sensor: when the kettle, the water dispenser, and the microwave are On.");
[ kettle, waterDisp, microwave ] = queryZplug(database, startDate, endDate);

disp('------------------------------------------------------------------------------------');
% SNYC DATA

disp("[ 4/10] Synchronizing data between 'TemperatureDoor' and 'Humidity' sensors.");
tempWindHum = syncTempSmth(database, 12, 13, startDate, endDate);
tempWindHum = deleteDuplicateSensor(tempWindHum);

% the timeline is defined as the array of timestamps of the TemperatureDoor
timeline=tempWindHum(2,:);

disp("[ 5/10] Synchronizing data between 'TemperatureDoor' and 'TemperatureWindow' sensors.");
tempWindTempDoor=syncTempSmth(database, 12, 10, startDate, endDate);
tempWindTempDoor = deleteDuplicateSensor(tempWindTempDoor);


disp('------------------------------------------------------------------------------------');
% MATCHING DATA
disp("[ 6/10] Matching data: when 'Movement' sensor is On.");
Bnet(1,:) = matchingSensorInterval(movement, timeline);
disp("[ 7/10] Matching data: when 'WindowOpen' sensor is On.");
Bnet(2,:) = matchingSensorInterval(windowOpen, timeline);
disp("[ 8/10] Matching Data: when 'Kettle' is On.");
Bnet(3,:) = matchingZplugInterval(kettle(3,:), timeline);
disp("[ 9/10] Matching Data: when 'WaterDispenser' is On.");
Bnet(4,:) = matchingZplugInterval(waterDisp(3,:), timeline);
disp("[10/10] Matching Data: when 'Microwave' is On.");
Bnet(5,:) = matchingZplugInterval(microwave(3,:), timeline);
 
Bnet(6,:) = tempWindHum(1,:);
Bnet(7,:) = tempWindHum(3,:);
Bnet(8,:) = tempWindTempDoor(3,:);
disp('------------------------------------------------------------------------------------');

fprintf("Saving all the variables in '<strong>bNet_data.mat</strong>'...");
save('bNet_data.mat');
fprintf("Done!\n");
disp('------------------------------------------------------------------------------------');
end
