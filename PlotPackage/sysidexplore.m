function [] = sysidexplore(INFO,FMT,fig)
%plots system identification data
%


fig.Name = 'System Identification Data';
clf(fig);

%% RAW RSSI AND NOISE DATA
s(1) = subplot(4,1,1);
rc1in = plot(FMT.RCIN.TimeS,FMT.RCIN.C1,'-b');
hold on
rc1ou = plot(FMT.RCOU.TimeS,FMT.RCOU.C1,'-r');
grid on
box on
ylabel('Roll Input');
legend([rc1in rc1ou],{'RC 1 IN','RC 1 OUT'});
axis tight


s(2) = subplot(4,1,2);
p_rad = plot(FMT.IMU.TimeS,FMT.IMU.GyrX*180/pi,'-b');
hold on
hold off
grid on
ylabel('Roll Output');
legend([p_rad],{'Roll Rate, deg/s'});
axis tight

s(3) = subplot(4,1,3);
rc2in = plot(FMT.RCIN.TimeS,FMT.RCIN.C2,'-b');
hold on
rc2ou = plot(FMT.RCOU.TimeS,FMT.RCOU.C2,'-r');
grid on
box on
ylabel('Pitch Input');
legend([rc2in rc2ou],{'RC 2 IN','RC 2 OUT'});
axis tight

s(4) = subplot(4,1,4);
p_rad = plot(FMT.IMU.TimeS,FMT.IMU.GyrY*180/pi,'-b');
hold on
hold off
grid on
ylabel('Roll Output');
legend([p_rad],{'Pitch Rate, deg/s'});
axis tight


linkaxes(s,'x');
clear s