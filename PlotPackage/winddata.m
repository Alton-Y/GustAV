function [] = winddata(INFO,FMT,GND,AVT,fig)
%Plots ground station data
fig.Name = 'Wind Data';
clf(fig);

s1 = subplot(4,1,1);
hold on

%press
pgnd = plot(GND.ATMO.TimeS,GND.ATMO.Pressure,'-k');
palt = plot(FMT.BARO.TimeS,FMT.BARO.Press,'--b');
pavt = plot(AVT.ADP.TimeS,AVT.ADP.P_STATIC,'--r');

ylabel('Pressure');
axis tight
% datetick('x','HH:MM:SS')
legend([pgnd,palt,pavt],{'Pressure GND','Pressure Pixhawk','Pressure Aventech'},'location','northwest')
grid on
box on

s2= subplot(4,1,2);
hold on

tgnd = plot(GND.ATMO.TimeS,GND.ATMO.TempC,'-k');
tair_imu = plot(FMT.IMU.TimeS,FMT.IMU.Temp,'--b');
tair_arsp = plot(FMT.ARSP.TimeS,FMT.ARSP.Temp,'-b');
tfast = plot(AVT.ADP.TimeS,AVT.ADP.TempFast,'-.r');
tavt = plot(AVT.ADP.TimeS,AVT.ADP.Temp,'-r');

legend([tgnd,tair_imu,tair_arsp,tfast,tavt],{'Temp GND','Temp Pix IMU',...
    'Temp Pix ARSP','Temp Aventech Fast','Temp Aventech'},'location','northwest')
ylabel('Temp C')
axis tight
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

s3=subplot(4,1,3);
hold on
%wind speed ground
yyaxis left
gnd=plot(GND.ATMO.TimeS(GND.ATMO.TimeS>min(FMT.WIND.TimeS)),GND.ATMO.WindSpeed(GND.ATMO.TimeS>min(FMT.WIND.TimeS)),'-k');
ylabel('Velocity GND (m/s)');
ax = gca;
ax.YColor = 'k';
yyaxis right
air=plot(FMT.WIND.TimeS,FMT.WIND.SPD,'--b');
ylabel('Velocity ALT (m/s)');
ax = gca;
ax.YColor = 'b';
% datetick('x','HH:MM:SS')
axis tight
if isempty(gnd)==1 %if there is no gndstation
    legend([air],{'Wind Speed ALT'},'location','northwest')
else
    legend([air,gnd],{'Wind Speed ALT','Wind Speed GND'},'location','northwest')
end
grid on
box on

s4=subplot(4,1,4);
hold on
%wind dir
gnd=plot(GND.ATMO.TimeS(GND.ATMO.TimeS>min(FMT.WIND.TimeS)),GND.ATMO.WindDirection(GND.ATMO.TimeS>min(FMT.WIND.TimeS)),'-k');
air=plot(FMT.WIND.TimeS,FMT.WIND.DIR,'--b');
ylabel('Wind Direction (deg)')
if isempty(gnd)==1 %if there is no gndstation
    legend([air],{'Wind Direction ALT (from)'},'location','northwest')
else
    legend([gnd,air],{'Wind Direction GND (from)','Wind Direction ALT (from)'},'location','southwest')
end
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

linkaxes([s1,s2,s3,s4],'x');
try
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3 s4