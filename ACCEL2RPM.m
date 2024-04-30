clear rpm_accel
clear  rpm_accel_TimeS
clf
rpm_accel_TimeS = nan;
samples = 3000;
step = 50;
for i = samples/2 : step : size(FMT.ACC(1).TimeS,1)-samples/2
    % for i = 1: size(FMT.ACC(1).TimeS,1)
rpm_accel(i,:) = fftsample(FMT.ACC(1).AccY(i-(samples/2)+1:i+(samples/2)),2000,0).*60.*1;
rpm_accel_TimeS(i,:) = FMT.ACC(1).TimeS(i);
end

plot(FMT.RPM.TimeS,FMT.RPM.rpm1,'.');
hold on
plot(rpm_accel_TimeS,rpm_accel,'.');
legend('RPM sens','RPM accel FFT')
grid on