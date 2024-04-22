figure(2)
clf

s1=subplot(5,1,1)
hold on
plot(FMT.CTUN.TimeS,FMT.CTUN.As)
% plot(FMT.CTUN.TimeS,FMT.CTUN.SAs)
plot(FMT.ARSP(1).TimeS,FMT.ARSP(1).Airspeed)
% plot(FMT.ARSP(2).TimeS,FMT.ARSP(2).Airspeed)
grid on
ylabel('ARSP')
legend('EAS','ARSP1','ARSP2')
s2=subplot(5,1,2)
plot(FMT.RCOU.TimeS,FMT.RCOU.C3)
grid on
ylabel('Thr')
s3=subplot(5,1,3)
plot(FMT.XKF1(1).TimeS,FMT.XKF1(1).VD)
ylabel('VD')
grid on
s4=subplot(5,1,4)
hold on
plot(FMT.IMU(1).TimeS,FMT.IMU(1).AccZ,'.')
plot(FMT.IMU(1).TimeS,smooth(FMT.IMU(1).AccZ,25))
ylabel('AccZ')
grid on
s5=subplot(5,1,5)
hold on
plot(FMT.ATT(1).TimeS,FMT.ATT.Roll,'.')
ylabel('Roll')
grid on
linkaxes([s1,s2,s3,s4,s5],'x')