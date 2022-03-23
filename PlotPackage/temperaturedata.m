function [] = temperaturedata(INFO,FMT,GND,TEMPLOG,fig)
%Plots ground station data
fig.Name = 'Temperature Data';
clf(fig);

%%
s1 = subplot(3,1,1);
hold on
try
%press
% temps=plot(TEMPLOG.TimeS,TEMPLOG.TempC,'.');
mppt = plot(FMT.BAT3.TimeS(:),FMT.BAT3.CurrTot(:)./100,'.');
% pavt = plot(AVT.ADP.TimeS,AVT.ADP.P_STATIC,'--r');

% a = cellstr(TEMPLOG.Name);
% a{end+1} = 'MPPT';
legend([mppt],{'MPPT'},'Location','best')
end
ylabel('Temp C');
axis tight
% ylim([0 30]);
% datetick('x','HH:MM:SS')
% legend([pgnd,palt],{'Pressure GND','Pressure Pixhawk'},'location','northwest')
grid on
box on
%%
s2= subplot(3,1,2);
hold on

% tgnd = plot(GND.ATMO.TimeS,GND.ATMO.TempC,'-k');

  tair_imu = plot(FMT.IMU(1).TimeS,FMT.IMU(1).T,'--b');  %AP3.8

tair_arsp = plot(FMT.ARSP(1).TimeS,FMT.ARSP(1).Temp,'-b');

try
tair_arsp2 = plot(FMT.ARSP(2).TimeS,FMT.ARSP(2).Temp,'--k');
esc = plot(FMT.ESC(3).TimeS,FMT.ESC(3).Temp,'.r');
catch
end
try
legend([tair_imu,tair_arsp,tair_arsp2,esc],{'FC IMU',...
    'ARSP Sensor','ARSP2 Sensor','Motor Controller'},'location','northeast')
catch
    
 legend([tgnd,tair_imu,tair_arsp],{'Ground Station','FC IMU',...
    'ARSP Sensor'},'location','northeast')   
end  
% tfast = plot(AVT.ADP.TimeS,AVT.ADP.TempFast,'-.r');
% tavt = plot(AVT.ADP.TimeS,AVT.ADP.Temp,'-r');

ylabel('Temp C')
axis tight
% datetick('x','HH:MM:SS')
axis tight
grid on
box on
 xlabel('Time, S')
 
 
 s3= subplot(3,1,3)
 hold on
 try
 batt1= plot(FMT.BCL(3).TimeS,FMT.BCL(3).V7./100-50);
 batt2= plot(FMT.BCL(3).TimeS,FMT.BCL(3).V8./100-50);
 batt3= plot(FMT.BCL(3).TimeS,FMT.BCL(3).V9./100-50);
 end
ylabel('Temp C')
axis tight
% datetick('x','HH:MM:SS')
axis tight
grid on
box on
 xlabel('Time, S')
%%
linkaxes([s1,s2],'x');
try
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2