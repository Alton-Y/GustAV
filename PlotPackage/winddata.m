function [] = winddata(INFO,FMT,GND,AVT,fig)
%Plots ground station data
fig.Name = 'Wind Data';
clf(fig);

s1 = subplot(4,1,1);
hold on

%press
try
pgnd = plot(GND.ATMO.TimeS,GND.ATMO.Pressure,'-k');
end
palt = plot(FMT.BARO(1).TimeS,FMT.BARO(1).Press,'--b');
% pavt = plot(AVT.ADP.TimeS,AVT.ADP.P_STATIC,'--r');

ylabel('Pressure');
axis tight
% datetick('x','HH:MM:SS')
if exist('pgnd','var')
legend([pgnd,palt],{'Pressure GND','Pressure Pixhawk'},'location','northwest')
else
    legend([palt],{'Pressure Pixhawk'},'location','northwest')
end
grid on
box on

% s2= subplot(4,1,2);
% hold on
% 
% try
% tgnd = plot(GND.ATMO.TimeS,GND.ATMO.TempC,'-k');
% catch
% end
% try
%   tair_imu = plot(FMT.IMU.TimeS,FMT.IMU.T,'--b');  %AP3.8
% catch
%     tair_imu = plot(FMT.IMU.TimeS,FMT.IMU.Temp,'--b'); %earlier AP version
% end
% tair_arsp = plot(FMT.ARSP.TimeS,FMT.ARSP.Temp,'-b');
% try
%   tair_arsp2 = plot(FMT.ASP2.TimeS,FMT.ASP2.Temp,'--k');
%   legend([tgnd,tair_imu,tair_arsp,tair_arsp2],{'Temp GND','Temp Pix IMU',...
%     'Temp Pix ARSP','Temp Pix ARSP2'},'location','northwest')
% % tfast = plot(AVT.ADP.TimeS,AVT.ADP.TempFast,'-.r');
% % tavt = plot(AVT.ADP.TimeS,AVT.ADP.Temp,'-r');
% catch
% legend([tgnd,tair_imu,tair_arsp],{'Temp GND','Temp Pix IMU',...
%     'Temp Pix ARSP'},'location','northwest')
% end
% ylabel('Temp C')
% axis tight
% % datetick('x','HH:MM:SS')
% axis tight
% grid on
% box on

s3=subplot(4,1,2);
hold on
%wind speed ground
% yyaxis left
try
gnd=plot(GND.ATMO.TimeS(GND.ATMO.TimeS>min(FMT.WIND.TimeS)),GND.ATMO.WindSpeed(GND.ATMO.TimeS>min(FMT.WIND.TimeS)),'-k');
ylabel('Velocity GND (m/s)');
% ax = gca;
% ax.YColor = 'k';
end
% yyaxis right
air=plot(FMT.WIND.TimeS,FMT.WIND.SPD,'--b');
ylabel('Velocity ALT (m/s)');
% ax = gca;
% ax.YColor = 'b';
% datetick('x','HH:MM:SS')
axis tight
if isnan(GND) %if there is no gndstation
    legend([air],{'Wind Speed ALT'},'location','northwest')
else
    legend([air,gnd],{'Wind Speed ALT','Wind Speed GND'},'location','northwest')
end
grid on
box on

s4=subplot(4,1,3);
hold on
%wind dir
try
gnd=plot(GND.ATMO.TimeS(GND.ATMO.TimeS>min(FMT.WIND.TimeS)),GND.ATMO.WindDirection(GND.ATMO.TimeS>min(FMT.WIND.TimeS)),'-k');
end

air=plot(FMT.WIND.TimeS,FMT.WIND.DIR,'--b');
ylabel('Wind Direction (deg)')
if isnan(GND)%if there is no gndstation
    legend([air],{'Wind Direction ALT (from)'},'location','northwest')
else
    legend([gnd,air],{'Wind Direction GND (from)','Wind Direction ALT (from)'},'location','southwest')
end
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

linkaxes([s1,s3,s4],'x');
try
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3 s4