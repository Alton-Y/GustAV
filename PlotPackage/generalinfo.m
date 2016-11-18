function [] = generalinfo(INFO,FMT,GNDSTN,fig)
%Plots airspeed, altitude, yaw, track, roll, pitch and control inputs


fig.Name = 'General Info';
clf(fig);
% set(gcf,'numbertitle','off','name','myfigure') % See the help for GCF

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
%throttle
thr=plot(FMT.RCIN.TimeS,FMT.RCIN.C3,'-r');
legend([ail,elv,rud,thr],{'Aileron','Elevator','Rudder','Throttle'},'location','northwest')
ylabel('Control Request')
axis tight
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

linkaxes([s1,s2,s3,s4],'x');
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
clear s1 s2 s3 s4