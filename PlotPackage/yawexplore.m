figure
s1=subplot(5,1,1)
hold on
plot(FMT.IMU(1).TimeS,smooth(FMT.IMU(1).AccY,100).*100,'.')

legend('Y- accel')
ylabel('m/s/s *100')
grid on 
box on


s2=subplot(5,1,2)
hold on
plot(FMT.CTUN.TimeS,FMT.CTUN.NavRoll,'.')
plot(FMT.CTUN.TimeS,FMT.CTUN.Roll,'.')
yyaxis right
plot(FMT.IMU(1).TimeS,FMT.IMU(1).GyrZ,'.');
legend('Nav Roll','Roll')
grid on 
box on

s3=subplot(5,1,3)
hold on
plot(FMT.IMU(1).TimeS,FMT.IMU(1).GyrZ,'.');

as=interp1(FMT.CTUN.TimeS,FMT.CTUN.As,FMT.IMU(1).TimeS);
rll=interp1(FMT.ATT(1).TimeS,FMT.ATT(1).Roll,FMT.IMU(1).TimeS);
thyawrate=(9.81 ./ as) .* sind(rll) .* 1.0;
plot(FMT.IMU(1).TimeS,thyawrate,'.');
grid on
box on

legend('Yaw Rate','Yaw Rate Theory')
s4=subplot(5,1,4)
hold on
plot(FMT.RCOU.TimeS,FMT.RCOU.C4,'.')
legend('Rudder')
grid on
box on

s5=subplot(5,1,5)
hold on
plot(FMT.IMU(1).TimeS,FMT.IMU(1).GyrZ-thyawrate,'.')
plot(FMT.IMU(1).TimeS,smooth(FMT.IMU(1).GyrZ-thyawrate,5000,'moving'),'-')
ylim([-0.2 0.2])
yyaxis right
hold on
plot(FMT.PIDY.TimeS,FMT.PIDY.I)
% plot(FMT.PIDY.TimeS,FMT.PIDY.D)
legend('Err','avg error','PIDI')
grid on 
box on


linkaxes([s1,s2,s3,s4,s5],'x')

