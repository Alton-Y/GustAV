function [] = airspeedexplore(INFO,FMT,fig)
%plots airspeed from multiple sensors


fig.Name = 'Airspeed Data';
clf(fig);

%% 
s(1) = subplot(5,1,1);
hold on

arsp = plot(FMT.ARSP(1).TimeS, FMT.ARSP(1).Airspeed,'.-k');
try
arsp2 = plot(FMT.ARSP(2).TimeS, FMT.ARSP(2).Airspeed,'.--b');
catch
    warning('Only one airspeed sensor in data');
end

avg = plot(FMT.CTUN.TimeS,FMT.CTUN.As,'.-g');
try
legend([arsp,arsp2,avg],{'Sensor 0','Sensor 1','Airspeed Est'});
catch
legend([arsp,avg],{'Sensor 0','Airspeed Est'});
end
ylabel('Raw airspeed, m/s')

box on
grid on





%% 
s(2) = subplot(5,1,2);
hold on

temp = plot(FMT.ARSP(1).TimeS, FMT.ARSP(1).Temp,'-k');
try
temp2 = plot(FMT.ARSP(2).TimeS, FMT.ARSP(2).Temp,'--b');
catch
end
gndtmp = plot(FMT.BARO(1).TimeS, FMT.BARO(1).GndTemp,'.r');
try
legend([temp,temp2,gndtmp],{'Sensor 0','Sensor 1','GND TEM'});
catch
 legend([temp,gndtmp],{'Sensor 0','GND TEM'});   
end
box on
grid on


%% 
s(3) = subplot(5,1,3);
yyaxis left
hold on
arsph = plot(FMT.ARSP(1).TimeS, FMT.ARSP(1).H,'+-k');
try
arsp2h = plot(FMT.ARSP(2).TimeS, FMT.ARSP(2).H,'+--b');
catch
end
ylim([-2 1]);
ylabel('Health')

yyaxis right
hold on

  arspp = plot(FMT.ARSP(1).TimeS, FMT.ARSP(1).Pri,'.-k');  

try
arsp2p = plot(FMT.ARSP(1).TimeS,FMT.ARSP(2).Pri,'.--b');
arsp3p = plot(FMT.XKFS(1).TimeS,FMT.XKFS(1).AI,'.--g');
catch
end
ylim([0 3]);

box on
grid on
ylabel('Primary')

% legend([arsp,arsp2],{'Sensor 1','Sensor 2'});

%% 
s(4) = subplot(5,1,4);
hold on
arspp = plot(FMT.ARSP(1).TimeS, abs(FMT.ARSP(1).Airspeed.^2./FMT.ARSP(1).RawPress),'.-k');
try
arsp2p = plot(FMT.ARSP(2).TimeS, abs(FMT.ARSP(2).Airspeed.^2./FMT.ARSP(2).RawPress),'.--b');
catch
end

box on
grid on
ylim([1.7 4]);
ylabel('AS Ratio');


yyaxis right
hold on
try
rat = FMT.TECS.sp./interp1(FMT.CTUN.TimeS,FMT.CTUN.As,FMT.TECS.TimeS);
eastas = plot(FMT.TECS.TimeS,rat,'.r');
eastas2 = plot(FMT.CTUN.TimeS,FMT.CTUN.E2T,'.g')
ylim([0.8 1.2]);
catch
end
ax = gca;
ax.YColor = 'r';
ylabel('EAS2TAS Ratio');

yyaxis left
% tempK = FMT.BARO.GndTemp + 273.15 - (0.0065 .* FMT.BARO.Alt);
% den = FMT.BARO.Press ./ (287.26 .* tempK)
%%
s(5)=subplot(5,1,5); %airspeed error (should be below 0.3. Above 1 data from pitot is ignored)
if isfield(FMT,'NKF4')
hold on
yyaxis left
imu1=plot(FMT.NKF4.TimeS,FMT.NKF4.SVT,'--b');
imu2=plot(FMT.NKF9.TimeS,FMT.NKF9.SVT,'--r');
maxl = plot([min(FMT.NKF4.TimeS) max(FMT.NKF4.TimeS)],[1 1],'-r');
ax = gca;
ax.YColor = 'k';
ylabel('Error Ratio');
axis tight

yyaxis right
hold on
ivt= plot(FMT.NKF3.TimeS,FMT.NKF3.IVT,'-k');
ivt2= plot(FMT.NKF8.TimeS,FMT.NKF8.IVT,'--k');
ax = gca;
ax.YColor = 'k';
ylabel('Airspeed Innovation');
grid on
box on


else
    
    hold on
yyaxis left
imu1=plot(FMT.XKF4(1).TimeS,FMT.XKF4(1).SVT,'--b');
imu2=plot(FMT.XKF4(2).TimeS,FMT.XKF4(2).SVT,'--r');
maxl = plot([min(FMT.XKF4(1).TimeS) max(FMT.XKF4(1).TimeS)],[1 1],'-r');
ax = gca;
ax.YColor = 'k';
ylabel('Error Ratio');
axis tight

yyaxis right
hold on
ivt= plot(FMT.XKF3(1).TimeS,FMT.XKF3(1).IVT,'-k');
ivt2= plot(FMT.XKF3(2).TimeS,FMT.XKF3(2).IVT,'--k');
ax = gca;
ax.YColor = 'k';
ylabel('Airspeed Innovation');
grid on
box on

end
axis tight
linkaxes(s,'x');
axis tight
clear s