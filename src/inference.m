gran=1;

pTempWin = exactInference(bnetParHid, tempWin, window);
range=minTempWin/(10^gran):(0.1^gran):maxTempWin/(10^gran);
figure;
bar(range, pTempWin);
xlabel('Domain Temperature Window (t)');
ylabel('P(Temp=t)');
title('Estimation of P(TempWin)');
grid on

pHumidity = exactInference(bnetParHid, humidity, window);
range=minHumidity/(10^gran):(0.1^gran):maxHumidity/(10^gran);
figure;
bar(range, pHumidity);
xlabel('Domain % Humidity (h)');
ylabel('P(Hum=h)');
title('Estimation of P(Hum)');
grid on


pTempDoor = exactInference(bnetParHid, tempDoor, window);
range=minTempDoor/(10^gran):(0.1^gran):maxTempDoor/(10^gran);
figure;
bar(range, pTempDoor);
xlabel('Domain Temperature Door (t)');
ylabel('P(Temp=t)');
title('Estimation of P(TempDoor)');
grid on
