clc
clear


FMT = FMT_Load('logs/Bix3/2016-06-04_Flight1.mat');
INFO.Aircraft = 'Bix 3';
INFO = FMT_GetInfo(INFO,FMT);



%%
subplot(3,1,1)
plot([FMT.BARO.TimeUS],[FMT.BARO.Alt])

subplot(3,1,2)
plot([FMT.BARO.TimeUS],[FMT.BARO.Temp])

subplot(3,1,3)
% plot([FMT.BARO.TimeUS(2:end)],diff([FMT.BARO.Temp]))