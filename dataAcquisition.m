% Data acquisition

addpath(genpath('dataAcquisition'));
fprintf("<strong>Extracting, synchronizing, and matching the data from the database...</strong>\n");
dataBnet = createDataBNet('database/until12_07_26.sqlite', '2012-06-26 00:00:00', '2012-06-29 00:00:00');
fprintf("<strong>Creating matrix 'dataBnet.mat'...</strong>");
save('dataBNet.mat');
fprintf("<strong>Done!</strong>\n");