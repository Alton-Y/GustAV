function tecsexplore(INFO,FMT,GNDSTN,fig)
fig.Name = 'TECS Explore';
clf(fig);
try
s1=subplot(3,1,1);
hold on
hdem=plot(FMT.TECS.TimeS,FMT.TECS.hdem,'-k');
h=plot(FMT.TECS.TimeS,FMT.TECS.h,'--b');
legend([hdem,h],{'demanded alt','alt'},'location','northwest');
ylabel('m AGL');
axis tight
grid on
box on

s2=subplot(3,1,2);
hold on
sdem=plot(FMT.TECS.TimeS,FMT.TECS.spdem,'-k');
s=plot(FMT.TECS.TimeS,FMT.TECS.sp,'--b');
legend([sdem,s],{'demanded arsp','arsp'},'location','northwest');
ylabel('m/s');
axis tight
grid on
box on
catch
end
s3=subplot(3,1,3);
hold on
thr=plot(FMT.RCOU.TimeS,FMT.RCOU.C3,'-k');
legend([thr],{'throttle'},'location','northwest');
ylabel('PWM sig.');
axis tight
grid on
box on

try
linkaxes([s1,s2,s3],'x');

xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
clear s1 s2 s3
catch
end