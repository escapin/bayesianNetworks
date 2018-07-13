gran=0;
zPlug=4;
presence=2;
pZplug = exactInference(bnetCPT, zPlug, presence);
range=minmaxVe/(10^gran):(1^gran):maxZplugPower/(10^gran);
figure;
bar(range, pZplug);
xlabel('Domain Zplug power (W)');
ylabel('P(zPlug=w)');
title('Estimation of P(zPlug)');
grid on
