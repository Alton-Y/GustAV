function [] = RPcontrolexplorePITCH(INFO,FMT,GND,fig)
%plots info related to Roll/Pitch controllers

fig.Name = 'Roll/Pitch Controller Info 2';
clf(fig);
% 
% paramchange = importparamchangefile('tuning.txt');
% starttime= datetime(INFO.pixhawkstart(1)-6/24,'convertfrom','datenum');
% changetime = datenum(paramchange.date) + datenum(hour(paramchange.time)./24) +...
%     datenum(minute(paramchange.time)./(24*60) + datenum(second(paramchange.time)+20)./(86400));
% paramchangeSec = (changetime-(INFO.pixhawkstart-(6/24)) ).*86400;
% while length(find((diff(paramchangeSec)<0.25)) >1)
% idx=find((diff(paramchangeSec)<0.25))
% paramchangeSec(idx+1) = paramchangeSec(idx+1) + 0.25;
% end

s1=subplot(4,1,1);
hold on
plot(FMT.CTUN.TimeS,FMT.CTUN.Pitch,'.')
% plot(FMT.CTUN.TimeS,FMT.CTUN.NavPitch,'.')
plot(FMT.CTUN.TimeS,FMT.CTUN.NavPitch+3,'.')
legend('Act pitch','Target pitch','Location','best')

yyaxis right
plot(INFO.segment.startTimeS,zeros(length(INFO.segment.startTimeS),1),'+k');
text(INFO.segment.startTimeS,zeros(length(INFO.segment.startTimeS),1),INFO.segment.modeAbbr,'Rotation',90);

% texttodisp = paramchange.param + ': ' + paramchange.old./1000000 + '->' + paramchange.new./1000000;
% text(paramchangeSec,zeros(length(paramchangeSec),1),texttodisp,'Rotation',90,'Color','b','Interpreter','none')
ylim([0 2]);

yyaxis left
% yyaxis right

ylabel('Pitch Angle')

grid on

axis tight

% xlim([2936 2947])

s2=subplot(4,1,2);
hold on
plot(FMT.PIDP.TimeS,FMT.PIDP.Act,'.-')
plot(FMT.PIDP.TimeS,FMT.PIDP.Tar,'.-')
plot(FMT.CTUN.TimeS,(FMT.CTUN.NavPitch-FMT.CTUN.Pitch)./1.2);
% plot(FMT.CTUN.TimeS,(FMT.CTUN.NavPitch+3-FMT.CTUN.Pitch)./0.75,'.-');
ylabel('Rate')
legend('Act','Tar','My Targ','Location','best')
grid on

axis tight

% xlim([2936 2947])


s3=subplot(4,1,3);
hold on
plot(FMT.PIDP.TimeS,FMT.PIDP.FF,'.-')
plot(FMT.PIDP.TimeS,FMT.PIDP.P,'.-')
plot(FMT.PIDP.TimeS,FMT.PIDP.D,'.-')
plot(FMT.PIDP.TimeS,FMT.PIDP.I,'.-')
ylabel('Rate')
legend('FF','P','D','I','Location','best')
grid on

axis tight

% xlim([2936 2947])

s4=subplot(4,1,4);
hold on
% plot(FMT.AETR.TimeS,FMT.AETR.Elev./(4500),'.-')
% ylabel('ELEV')

plot(FMT.RCOU.TimeS,FMT.RCOU.C2,'.-')
% ylabel('PWM')
% % legend('FF','P','D','Location','best')
% grid on
% 
% yyaxis right
ylabel('ELEV')

plot(FMT.AETR.TimeS,FMT.AETR.Elev.*0.01,'.-r');
plot(FMT.RCOU.TimeS,(FMT.RCOU.C2-1380)./500 .*45);
% % plot(FMT.PIDP.TimeS,FMT.PIDP.Act.*cell2mat(FMT.PARM(636,2)).*(interp1(FMT.AETR.TimeS,FMT.AETR.SS,FMT.PIDP.TimeS)),'.-b');
plot(FMT.PIDP.TimeS,FMT.PIDP.Act.*0.65.*(interp1(FMT.AETR.TimeS,FMT.AETR.SS,FMT.PIDP.TimeS)),'.-b');
% legend('FF','P','D','Location','best')
grid on
legend('PWM','Elev','Elev from RC','FF perf')


axis tight

% xlim([2936 2947])

% s4= subplot(4,1,4)
% hold on
plot(FMT.PIDP.TimeS,FMT.PIDP.Dmod)
% grid on
% 
% axis tight

linkaxes([s1,s2,s3,s4],'x');