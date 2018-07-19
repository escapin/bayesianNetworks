clear all
close all

database ='database/until12_07_26.sqlite';
startDate = '2012-06-26 00:00:00';
endDate = '2012-06-28 00:00:00';


addpath(genpath('dataAcquisition'));

fprintf("Extracting and computing the Bayesian Network with data from <strong>%s</strong> to <strong>%s</strong>.\n", startDate, endDate);
[Bnet, timeline] = computeBnet(database, startDate, endDate);


disp("[11/10] Extracting data from the 'Zplug': 'Zplug' consumption.");
zPlug = unionZplug(database, startDate, endDate);

disp("[12/10] Calculating the minumum, the maximum, and the average of 'Zplug' consumption.");
[ minZplug, maxZplug, avgZplug ] = matchingZplugWattInterval(zPlug, timeline);


fprintf("Appending these variable to '<strong>bNet_data.mat</strong>'...");
save('bNet_data.mat','zPlug', 'minZplug', 'maxZplug', 'avgZplug', '-append');
fprintf("Done!\n");