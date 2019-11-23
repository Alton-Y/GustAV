function [] = motordata(INFO,FMT,fig)
%plots channel data

fig.Name = 'Motor Data';
clf(fig);

s1 = subplot(4,1,1);
hold on

%airspeed
yyaxis left
% find primary sensor data
idxp = FMT.ARSP.Primary==0;
allspeed = nan(size(FMT.ARSP.Airspeed));
allspeed(idxp) =FMT.ARSP.Airspeed(idxp);
try
    idxp2 = FMT.ASP2.Primary ==1;
    allspeed(idxp2) =FMT.ASP2.Airspeed(idxp2);
catch
end

arsp = plot(FMT.ARSP.TimeS,allspeed,'.-k');
ylabel('Airspeed (m/s)');
axis tight
ax = gca;
ax.YColor = 'k';
yyaxis right
alt = plot(FMT.BARO.TimeS,FMT.BARO.Alt,'--b');
ylabel('Baro Altitude (m)');
ax = gca;
ax.YColor = 'b';
axis tight
% datetick('x','HH:MM:SS')
axis tight
legend([arsp,alt],{'Airspeed', 'Altitude'},'location','northwest')
grid on
box on


s2 = subplot(4,1,2);
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

s3 =subplot(4,1,3);
hold on

%volts
yyaxis left
try
    volt=plot(FMT.BAT.TimeS,FMT.BAT.Volt,'-k');
catch
volt=plot(FMT.CURR.TimeS,FMT.CURR.Volt,'-k');
end
ylabel('Volts');
ax = gca;
ax.YColor = 'k';
yyaxis right
try
   amp = plot(FMT.BAT.TimeS,FMT.BAT.Curr,'--b'); 
catch
amp = plot(FMT.CURR.TimeS,FMT.CURR.Curr,'--b');
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
    volt=plot(FMT.BAT.TimeS,FMT.BAT.Volt.*FMT.BAT.Curr,'-k');
%     plot(FMT.BAT.TimeS,smooth(FMT.BAT.Volt.*FMT.BAT.Curr,2000,'loess'),'-r')
catch
volt=plot(FMT.CURR.TimeS,FMT.CURR.Volt*FMT.CURR.Curr,'-k');
end
ylabel('Electrical Power [W]');
ax = gca;
ax.YColor = 'k';

yyaxis right
plot(FMT.BAT.TimeS,FMT.BAT.EnrgTot,'-b');


axis tight
legend([volt,amp],{'Power'},'location','northwest')
grid on
box on
ylabel('Wh');

yyaxis left

linkaxes([s1,s2,s3,s4],'x');
% try
%     xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
% catch
%     axis tight
% end
clear s1 s2 s3