function [] = motordata(INFO,FMT,fig)
%plots channel data

fig.Name = 'Motor Data';
clf(fig);

s1 = subplot(4,1,1);
hold on

%airspeed
yyaxis left
% find primary sensor data
load=plot(FMT.CESC.TimeS,FMT.CESC.Pow,'.-k');
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
    rpm=plot(FMT.CESC.TimeS,FMT.CESC.RPM,'.-k');

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
try
    volt=plot(FMT.CESC.TimeS,FMT.CESC.Voltage,'-k');
catch
volt=plot(FMT.BAT.TimeS,FMT.BAT.Volt,'-k');
end
ylabel('Volts');
ax = gca;
ax.YColor = 'k';
yyaxis right
try
   amp = plot(FMT.CESC.TimeS,FMT.CESC.Curr,'--b'); 
catch
amp = plot(FMT.BAT.TimeS,FMT.BAT.Curr,'--b');
end
ylabel('Amps');
ax = gca;
ax.YColor = 'b';
axis tight
% datetick('x','HH:MM:SS')
axis tight
legend([volt,amp],{'Voltage', 'Amperage'},'location','northwest')
grid on
box on


s4 =subplot(4,1,4);
hold on

%power
yyaxis left
hold on
try
    volt=plot(FMT.CESC.TimeS,FMT.CESC.Voltage.*FMT.CESC.Curr,'-r');
%     plot(FMT.CESC.TimeS,smooth(FMT.CESC.Voltage.*FMT.CESC.Curr,20,'loess'),'-r')
catch

end
volt2=plot(FMT.BAT.TimeS,FMT.BAT.Volt.*FMT.BAT.Curr,'-k');
ax = gca;
ax.YColor = 'k';

% yyaxis right
% plot(FMT.BAT.TimeS,FMT.BAT.EnrgTot,'-b');


axis tight
legend([volt,volt2],{'Power ESC','Power Monitor'},'location','northwest')
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