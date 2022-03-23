function [] = generalinfo(INFO,FMT,GND,AVT,fig)
%Plots airspeed, altitude, yaw, track, roll, pitch and control inputs


fig.Name = 'General Info';
clf(fig);
% set(gcf,'numbertitle','off','name','myfigure') % See the help for GCF

s1 = subplot(4,1,1);
hold on

%airspeed
yyaxis left


arsp = plot(FMT.CTUN.TimeS,FMT.CTUN.As,'.-k');

arsp_g = plot(FMT.GPS(1).TimeS,FMT.GPS(1).Spd,'--g');
% arsp_avt = plot(AVT.OUT.TimeS, AVT.OUT.ARSP, '-r');


axis tight
ylabel('Airspeed (m/s)');
ax = gca;
ax.YColor = 'k';
yyaxis right
alt = plot(FMT.POS.TimeS,FMT.POS.RelHomeAlt,'--b');
ylabel('AGL Altitude (m)');
ax = gca;
ax.YColor = 'b';
axis tight
% datetick('x','HH:MM:SS')

    legend([arsp,arsp_g,alt],{'Pixhawk Airspeed',  'Pixhawk GPS Speed', 'RelHomeAlt'},'location','northwest')


grid on
box on
yyaxis left %make left axis active

s2= subplot(4,1,2);
hold on
%yaw
yaw=plot(FMT.ATT.TimeS,FMT.ATT.Yaw,'-k');
%track
track = plot(FMT.GPS(1).TimeS,FMT.GPS(1).GCrs,'--b');
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
ylabel('PWM')
axis tight
% datetick('x','HH:MM:SS')
% axis tight
ylim([1000 2000])

yyaxis right
plot(INFO.segment.startTimeS,zeros(length(INFO.segment.startTimeS),1),'+k');
text(INFO.segment.startTimeS,zeros(length(INFO.segment.startTimeS),1),INFO.segment.modeAbbr,'Rotation',90);
ylim([0 2]);

yyaxis left
grid on
box on
legend([ail,elv,rud,thr],{'AIL IN','ELE IN','RUD IN','THR IN'},'location','northwest')
linkaxes([s1,s2,s3,s4],'x');
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3 s4