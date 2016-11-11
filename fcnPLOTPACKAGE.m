function [] = fcnPLOTPACKAGE(INFO,FMT,GNDSTN)

%% plot 1 
figure(1)
clf(1)

s1 = subplot(4,1,1);
hold on

%airspeed
yyaxis left
arsp=plot(FMT.ARSP.TimeS,FMT.ARSP.Airspeed,'-k');
ylabel('Airspeed (m/s)');
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

s2= subplot(4,1,2);
hold on
%yaw
yaw=plot(FMT.ATT.TimeS,FMT.ATT.Yaw,'-k');
%track
track = plot(FMT.GPS.TimeS,FMT.GPS.GCrs,'--b');
legend([yaw,track],{'Heading','Track'},'location','northwest')
ylabel('Direction (deg)')
axis tight
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

s3 = subplot(4,1,3);
hold on
%roll
roll=plot(FMT.ATT.TimeS,FMT.ATT.Roll,'-k');
%pitch
pitch=plot(FMT.ATT.TimeS,FMT.ATT.Pitch,'--b');
legend([roll,pitch],{'Roll','Pitch'},'location','northwest')
ylabel('Angle (+Pitch Up, +LWD)')
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

s4 =subplot(4,1,4);
hold on
%aileron
ail=plot(FMT.RCIN.TimeS,FMT.RCIN.C1,'-k');
%elevator
elv=plot(FMT.RCIN.TimeS,FMT.RCIN.C2,'--b');
%rudder
rud=plot(FMT.RCIN.TimeS,FMT.RCIN.C4,'-.r');

legend([ail,elv,rud],{'Aileron','Elevator','Rudder'},'location','northwest')
ylabel('Control Request')
axis tight
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

linkaxes([s1,s2,s3,s4],'x');
clear s1 s2 s3 s4

%% plot 2 (wind data)

figure(2)
clf(2)

s1 = subplot(4,1,1);
hold on

s1 = subplot(4,1,1);
hold on

%press
pgnd = plot(GNDSTN.TimeS,GNDSTN.Pressure,'-k');
palt=plot(FMT.BARO.TimeS,FMT.BARO.Press,'--b');

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

clear s1 s2 s3 s4

%% tuning stuff
figure(3)
clf(3)

s1=subplot(4,1,1);
hold on
yyaxis left
dem=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 0),FMT.ATRP.Demanded(FMT.ATRP.Type == 0),'.k');
ach=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 0),FMT.ATRP.Achieved(FMT.ATRP.Type == 0),'.b');
ylabel('Rate (deg/s)')
ax = gca;
ax.YColor = 'k';
yyaxis right
p=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 0),FMT.ATRP.P(FMT.ATRP.Type == 0),'-k');
legend([dem,ach,p],{'Demanded Roll Rate','Achieved Roll Rate','P Gain'},'location','northwest')
% set(gca,'XTickMode','manual');
% datetick('x','HH:MM:SS')
axis tight
ylabel('P Gain')
% xlim([minx,maxx]);
ax = gca;
ax.YColor = 'k';
% set(gca,'XTickMode','manual');
% tickdata = get(gca,'XTick');
grid on
box on

s2=subplot(4,1,2)
hold on
dem=plot(FMT.CTUN.TimeS,FMT.CTUN.NavRoll,'-k');
ach=plot(FMT.CTUN.TimeS,FMT.CTUN.Roll,'-b');
legend([dem,ach],{'Demanded Roll','Achieved Roll'},'location','northwest')
ylabel('Angle (deg)')
% set(gca,'XTickMode','manual');
% datetick('x','HH:MM:SS')
axis tight
% set(gca,'XTickMode','manual');
grid on
box on

s3=subplot(4,1,3);
hold on
yyaxis left
dem=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 1),FMT.ATRP.Demanded(FMT.ATRP.Type == 1),'.k');
ach=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 1),FMT.ATRP.Achieved(FMT.ATRP.Type == 1),'.b');
ylabel('Rate (deg/s)')
ax = gca;
ax.YColor = 'k';
yyaxis right
p=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 1),FMT.ATRP.P(FMT.ATRP.Type == 1),'-k');
legend([dem,ach,p],{'Demanded Pitch Rate','Achieved Pitch Rate','P Gain'},'location','northwest')
% set(gca,'XTickMode','manual');
axis tight
% xlim([minx,maxx]);
% set(gca,'XTick',tickdata)
% datetick('x','HH:MM:SS','keeplimits')
ylabel('P Gain')
ax = gca;
ax.YColor = 'k';
grid on
box on

s4= subplot(4,1,4)
hold on
dem=plot(FMT.CTUN.TimeS,FMT.CTUN.NavPitch,'-k');
ach=plot(FMT.CTUN.TimeS,FMT.CTUN.Pitch,'-b');
legend([dem,ach],{'Demanded Pitch','Achieved Pitch'},'location','northwest')
ylabel('Angle (deg)')
% set(gca,'XTickMode','manual');
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

linkaxes([s1,s2,s3,s4],'x');
clear s1 s2 s3 s4