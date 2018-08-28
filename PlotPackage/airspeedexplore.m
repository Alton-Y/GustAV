function [] = airspeedexplore(INFO,FMT,fig)
%plots airspeed from multiple sensors


fig.Name = 'Airspeed Data';
clf(fig);

%% 
s(1) = subplot(5,1,1);
hold on

arsp = plot(FMT.ARSP.TimeS, FMT.ARSP.Airspeed,'.-k');
arsp2 = plot(FMT.ASP2.TimeS, FMT.ASP2.Airspeed,'.--b');
ylabel('Raw airspeed, m/s')

box on
grid on



legend([arsp,arsp2],{'Sensor 0','Sensor 1'});

%% 
s(2) = subplot(5,1,2);
hold on

temp = plot(FMT.ARSP.TimeS, FMT.ARSP.Temp,'-k');
temp2 = plot(FMT.ASP2.TimeS, FMT.ASP2.Temp,'--b');
ylabel('Temp, degC')
box on
grid on


%% 
s(3) = subplot(5,1,3);
yyaxis left
hold on
arsph = plot(FMT.ARSP.TimeS, FMT.ARSP.Health,'+-k');
arsp2h = plot(FMT.ASP2.TimeS, FMT.ASP2.Health,'+--b');
ylim([-2 1]);
ylabel('Health')

yyaxis right
hold on
arspp = plot(FMT.ARSP.TimeS, FMT.ARSP.Primary,'.-k');
arsp2p = plot(FMT.ASP2.TimeS, FMT.ASP2.Primary,'.--b');
ylim([0 3]);

box on
grid on
ylabel('Primary')

% legend([arsp,arsp2],{'Sensor 1','Sensor 2'});

%% 
s(4) = subplot(5,1,4);
hold on
arspp = plot(FMT.ARSP.TimeS, abs(FMT.ARSP.Airspeed.^2./FMT.ARSP.RawPress),'.-k');
arsp2p = plot(FMT.ASP2.TimeS, abs(FMT.ASP2.Airspeed.^2./FMT.ASP2.RawPress),'.--b');

box on
grid on
ylabel('AS Ratio')


s(5)=subplot(5,1,5); %airspeed error (should be below 0.3. Above 1 data from pitot is ignored)
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

axis tight
linkaxes(s,'x');
axis tight
clear s