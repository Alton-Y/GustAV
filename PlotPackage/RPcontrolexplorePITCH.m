function [] = RPcontrolexplorePITCH(INFO,FMT,GND,fig)
%plots info related to Roll/Pitch controllers

fig.Name = 'Roll/Pitch Controller Info 2';
clf(fig);

s1=subplot(4,1,1);
hold on
plot(FMT.PIDP.TimeS,FMT.PIDP.Act,'.')
plot(FMT.PIDP.TimeS,FMT.PIDP.Tar,'.')
ylabel('Rate')
legend('Act','Target','Location','best')
grid on

axis tight

% xlim([2936 2947])

% s2=subplot(4,1,2);
% hold on
% plot(FMT.PIDP.TimeS,FMT.PIDP.Err,'.')
% ylabel('Rate')
% legend('Err','Location','best')
% grid on
% 
% axis tight

% xlim([2936 2947])


s2=subplot(4,1,2);
hold on
plot(FMT.PIDP.TimeS,FMT.PIDP.FF,'.')
plot(FMT.PIDP.TimeS,FMT.PIDP.P,'.')
plot(FMT.PIDP.TimeS,FMT.PIDP.D,'.')
plot(FMT.PIDP.TimeS,FMT.PIDP.I,'.')
ylabel('Rate')
legend('FF','P','D','I','Location','best')
grid on

axis tight

% xlim([2936 2947])

s3=subplot(4,1,3);
hold on
plot(FMT.AETR.TimeS,FMT.AETR.Elev./(4500),'.')
ylabel('ELEV')
yyaxis right
plot(FMT.RCOU.TimeS,FMT.RCOU.C2,'.')
ylabel('PWM')
% legend('FF','P','D','Location','best')
grid on

axis tight

% xlim([2936 2947])

s4= subplot(4,1,4)
hold on
plot(FMT.PIDP.TimeS,FMT.PIDP.Dmod)
grid on

axis tight

linkaxes([s1,s2,s3,s4],'x');