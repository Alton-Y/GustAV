function ekfexplore(INFO,FMT,GNDSTN,fig)
fig.Name = 'EKF Explore';
clf(fig);

s1=subplot(4,1,1);
hold on
att=plot(FMT.ATT.TimeS,FMT.ATT.Roll,'-k');
imu1=plot(FMT.NKF1.TimeS,FMT.NKF1.Roll,'--b');
imu2=plot(FMT.NKF6.TimeS,FMT.NKF6.Roll,'--r');
legend([att,imu1,imu2],{'Roll ATT','Roll IMU1','Roll IMU2'},'location','northwest');
ylabel('Angle (deg)');
axis tight
grid on
box on

s2=subplot(4,1,2);
hold on
att=plot(FMT.ATT.TimeS,FMT.ATT.Pitch,'-k');
imu1=plot(FMT.NKF1.TimeS,FMT.NKF1.Pitch,'--b');
imu2=plot(FMT.NKF6.TimeS,FMT.NKF6.Pitch,'--r');
ylabel('Angle (deg)');
axis tight
grid on
box on
legend([att,imu1,imu2],{'Pitch ATT','Pitch IMU1','Pitch IMU2'},'location','northwest');

s3=subplot(4,1,3);
hold on
imu1=plot(FMT.NKF4.TimeS,FMT.NKF4.SVT,'--b');
imu2=plot(FMT.NKF9.TimeS,FMT.NKF9.SVT,'--r');
ylabel('Ratio');
axis tight
grid on
box on
legend([imu1,imu2],{'ARSP IMU1','ARSP IMU2'},'location','northwest');


linkaxes([s1,s2,s3],'x');
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
clear s1 s2 s3