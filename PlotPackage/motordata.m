function [] = motordata(INFO,FMT,fig)
%plots channel data

fig.Name = 'Motor Data';
clf(fig);

s1 = subplot(2,1,1);
hold on

%rpm
yyaxis left
rpm=plot(FMT.RPM.TimeS,FMT.RPM.rpm1,'-k');
ylabel('RPM');
ax = gca;
ax.YColor = 'k';
yyaxis right
thr = plot(FMT.RCOU.TimeS,FMT.RCOU.C3,'--b');
ylabel('PWM');
ax = gca;
ax.YColor = 'b';
axis tight
% datetick('x','HH:MM:SS')
axis tight
legend([rpm,thr],{'RPM','THR OUT'},'location','northwest')
grid on
box on

s2 =subplot(2,1,2);
hold on

%volts
yyaxis left
volt=plot(FMT.CURR.TimeS,FMT.CURR.Volt,'-k');
ylabel('Volts');
ax = gca;
ax.YColor = 'k';
yyaxis right
amp = plot(FMT.CURR.TimeS,FMT.CURR.Curr,'--b');
ylabel('Amps');
ax = gca;
ax.YColor = 'b';
axis tight
% datetick('x','HH:MM:SS')
axis tight
legend([volt,amp],{'Voltage', 'Amperage'},'location','northwest')
grid on
box on

linkaxes([s1,s2],'x');
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
        axis tight
end
clear s1 s2