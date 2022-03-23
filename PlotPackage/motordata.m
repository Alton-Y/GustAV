function [] = motordata(INFO,FMT,fig)
%plots channel data

fig.Name = 'Motor Data';
clf(fig);

s1 = subplot(4,1,1);
hold on

%airspeed
yyaxis left
% find primary sensor data
try
load=plot(FMT.ESC(3).TimeS,FMT.ESC(3).Pow,'.-k');
end
grid on
box on
ylabel('Load %');
ax = gca;
ax.YColor = 'k';
yyaxis right
thr = plot(FMT.RCOU.TimeS,FMT.RCOU.C3,'--b');
ylabel('PWM');
ax = gca;
ax.YColor = 'b';
axis tight
legend('Load','RC3OUT')

s2 = subplot(4,1,2);
hold on
%rpm
yyaxis left
rpmclean = FMT.ESC(3).RPM;
rpmclean(rpmclean>20000) = rpmclean(rpmclean>20000)-65535;
    rpm=plot(FMT.ESC(3).TimeS,rpmclean,'.-k');

ylabel('RPM');

% datetick('x','HH:MM:SS')
axis tight

    legend([rpm],{'RPM'},'location','northwest')
grid on
box on

s3 =subplot(4,1,3);
hold on

%volts
yyaxis left
hold on
    volt=plot(FMT.ESC(3).TimeS,FMT.ESC(3).Volt,'-k');

volt2=plot(FMT.BAT(1).TimeS,FMT.BAT(1).Volt,'-.k');

ylabel('Volts');
ax = gca;
ax.YColor = 'k';
yyaxis right
hold on
   amp = plot(FMT.ESC(3).TimeS,FMT.ESC(3).Curr,'--b'); 

amp2 = plot(FMT.BAT(1).TimeS,FMT.BAT(1).Curr,'-.b');

ylabel('Amps');
ax = gca;
ax.YColor = 'b';
axis tight
% datetick('x','HH:MM:SS')
axis tight
legend([volt,volt2,amp,amp2],{'Volt ESC','Volt BAT','Curr ESC','Curr BAT'},'location','northwest')
grid on
box on


s4 =subplot(4,1,4);
hold on

%power
yyaxis left
hold on
try
    volt3=plot(FMT.ESC(3).TimeS,FMT.ESC(3).Volt.*FMT.ESC(3).Curr,'-r');
%     plot(FMT.CESC.TimeS,smooth(FMT.CESC.Voltage.*FMT.CESC.Curr,20,'loess'),'-r')
catch

end
volt4=plot(FMT.BAT(1).TimeS,FMT.BAT(1).Volt.*FMT.BAT(1).Curr,'-k');
ax = gca;
ax.YColor = 'k';

% yyaxis right
% plot(FMT.BAT.TimeS,FMT.BAT.EnrgTot,'-b');


axis tight
legend([volt3,volt4],{'Power ESC','Power Monitor'},'location','northwest')
grid on
box on
ylabel('Watts');

yyaxis left

linkaxes([s1,s2,s3,s4],'x');
% try
%     xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
% catch
%     axis tight
% end
clear s1 s2 s3