function [] = motordata(INFO,FMT,fig)
%plots channel data

fig.Name = 'Motor Data';
clf(fig);

s1 = subplot(3,1,1);
hold on

%airspeed
yyaxis left
arsp=plot(FMT.ARSP.TimeS,FMT.ARSP.Airspeed,'-k');
ylabel('Airspeed (m/s)');
axis tight
ax = gca;
ax.YColor = 'k';
yyaxis right
alt = plot(FMT.BARO.TimeS,FMT.BARO.Alt,'--b');
ylabel('Altitude (m)');
ax = gca;
ax.YColor = 'b';
axis tight
% datetick('x','HH:MM:SS')
axis tight
legend([arsp,alt],{'Airspeed', 'Altitude'},'location','northwest')
grid on
box on


s2 = subplot(3,1,2);
hold on

%rpm
yyaxis left
if isfield(FMT,'RPM')==1
    rpm=plot(FMT.RPM.TimeS,FMT.RPM.rpm1,'.-k');
end
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
if isfield(FMT,'RPM')==1
    legend([rpm,thr],{'RPM','THR OUT'},'location','northwest')
else
    legend([thr],{'THR OUT'},'location','northwest')
end
grid on
box on

s3 =subplot(3,1,3);
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

linkaxes([s1,s2,s3],'x');
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3