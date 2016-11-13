function [] = winddata(INFO,FMT,GNDSTN,fig)
%Plots ground station data
fig.Name = 'Wind Data';
clf(fig);

s1 = subplot(4,1,1);
hold on

%press
pgnd = plot(GNDSTN.TimeS,GNDSTN.Pressure,'-k');
palt= plot(FMT.BARO.TimeS,FMT.BARO.Press,'--b');

ylabel('Pressure');
axis tight
% datetick('x','HH:MM:SS')
legend([pgnd,palt],{'Pressure GND','Pressure ALT',},'location','northwest')
grid on
box on

s2= subplot(4,1,2);
hold on

tgnd = plot(GNDSTN.TimeS,GNDSTN.TempC,'-k');
tair=plot(FMT.IMU.TimeS,FMT.IMU.Temp,'--b');

legend([tgnd,tair],{'Temp GND','Temp AIR'},'location','northwest')
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
gnd=plot(GNDSTN.TimeS(GNDSTN.TimeS>min(FMT.WIND.TimeS)),GNDSTN.WindSpeed(GNDSTN.TimeS>min(FMT.WIND.TimeS)),'-k');
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
legend([gnd,air],{'Wind Speed GND', 'Wind Speed ALT'},'location','northwest')
grid on
box on

s4=subplot(4,1,4);
hold on
%wind dir
gnd=plot(GNDSTN.TimeS(GNDSTN.TimeS>min(FMT.WIND.TimeS)),GNDSTN.WindDirection(GNDSTN.TimeS>min(FMT.WIND.TimeS)),'-k');
air=plot(FMT.WIND.TimeS,FMT.WIND.DIR,'--b');
ylabel('Wind Direction (deg)')
legend([gnd,air],{'Wind Direction GND (from)','Wind Direction ALT (from)'},'location','southwest')
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

linkaxes([s1,s2,s3,s4],'x');
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
clear s1 s2 s3 s4