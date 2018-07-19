clear all
database ='database/until12_07_26.sqlite';
startDate = '2012-06-26 00:00:00';
endDate = '2012-07-26 00:00:00';

load('matrices/dataBNet_12_06_26__12_07_28.mat', 'timeline');

addpath(genpath('computeDataZplug'));

zPlug = unionZplug(database, startDate, endDate);

%ZplugActive = struct2cell(zPlug);
%zPlugActive = zPlug(2:3,:);

%operation = @(x) max(x);


[ minZplug, maxZplug, avgZplug ] = matchingZplugWattInterval(zPlug, timeline);
