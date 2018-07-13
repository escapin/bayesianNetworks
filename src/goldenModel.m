gran=1;

tempData=cell2mat(data(tempWin,:));
occurrence=hist(tempData,maxTempWin-minTempWin+1);
pTempWinGM=occurrence / size(tempData,2);
range=minTempWin/(10^gran):(0.1^gran):maxTempWin/(10^gran);
figure;
bar(range, pTempWinGM);
xlabel('Domain Temperature Window (t)');
ylabel('P(Temp=t)');
title('Golden Model of P(TempWin)');
grid on

tempData=cell2mat(data(humidity,:));
occurrence=hist(tempData,maxHumidity-minHumidity+1);
pHumGM= occurrence / size(tempData,2);
range=minHumidity/(10^gran):(0.1^gran):maxHumidity/(10^gran);
figure;
bar(range, pHumGM);
xlabel('Domain % Humidity (h)');
ylabel('P(Hum=h)');
title('Golden Model of P(Hum)');
grid on


tempData=cell2mat(data(tempDoor,:));
occurrence=hist(tempData,maxTempDoor-minTempDoor+1);
pTempDoorGM= occurrence / size(tempData,2);
range=minTempDoor/(10^gran):(0.1^gran):maxTempDoor/(10^gran);
figure;
bar(range, pTempDoorGM);
xlabel('Domain Temperature Door (t)');
ylabel('P(Temp=t)');
title('Golden Model of P(TempDoor)');
grid on
