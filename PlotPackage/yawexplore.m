clf

s1=subplot(4,1,1)
hold on
plot(FMT.IMU.TimeS,smooth(FMT.IMU.AccY,100).*100,'.')

legend('Y- accel')
ylabel('m/s/s *100')
grid on 
box on


s2=subplot(4,1,2)
hold on
plot(FMT.CTUN.TimeS,FMT.CTUN.NavRoll,'.')
plot(FMT.CTUN.TimeS,FMT.CTUN.Roll,'.')

legend('Nav Roll','Roll')
grid on 
box on

s3=subplot(4,1,3)
hold on
plot(FMT.IMU.TimeS,FMT.IMU.GyrZ,'.');
grid on
box on

s4=subplot(4,1,4)
hold on
plot(FMT.RCOU.TimeS,FMT.RCOU.C4,'.')
legend('Rudder')

grid on 
box on


linkaxes([s1,s2,s3,s4],'x')

