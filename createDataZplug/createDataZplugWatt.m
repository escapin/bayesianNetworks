clear all
database ='database/until12_07_26.sqlite';
startDate = '2012-06-26 00:00:00';
endDate = '2012-07-28 00:00:00';

load('matrices/dataBNet_12_06_26__12_07_28.mat', 'timeline');



zPlug = unionZplug(database, startDate, endDate)

%ZplugActive = struct2cell(zPlug);
%zPlugActive = zPlug(2:3,:);

operation = @(x) max(x);

[ minZplug, maxZplug, avgZplug ] = matchingZplugWattInterval(zPlug, timeline, operation);
