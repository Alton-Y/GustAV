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