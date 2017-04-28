function [] = sitl(INFO,FMT,GND,fig)
%Plots airspeed, altitude, yaw, track, roll, pitch and control inputs


fig.Name = 'SITL Info';
clf(fig);
% set(gcf,'numbertitle','off','name','myfigure') % See the help for GCF

s1 = subplot(3,1,1);
hold on
% aileron
% ail=plot((FMT.RCIN.TimeS-FMT.RCIN.TimeS(find(FMT.RCIN.C1~=FMT.RCIN.C1(1),1))),FMT.RCIN.C1,'-ob','MarkerIndices',1:10:length(FMT.RCIN.C1));
elv=plot((FMT.RCOU.TimeS),FMT.RCOU.C2,'-sb');
% thr=plot((FMT.RCIN.TimeS-FMT.RCIN.TimeS(find(FMT.RCIN.C1~=FMT.RCIN.C1(1),1))),FMT.RCIN.C3,'-^b','MarkerIndices',1:10:length(FMT.RCIN.C1));
% range = [4950:6000]
% ail=plot(FMT.RCIN.TimeS(range)-FMT.RCIN.TimeS(range(1)),FMT.RCIN.C1(range),'-ok','MarkerIndices',1:10:length(FMT.RCIN.C1(range)));
% elv=plot(FMT.RCIN.TimeS(range)-FMT.RCIN.TimeS(range(1)),FMT.RCIN.C2(range),'-sk','MarkerIndices',1:10:length(FMT.RCIN.C1(range)));
% thr=plot(FMT.RCIN.TimeS(range)-FMT.RCIN.TimeS(range(1)),FMT.RCIN.C3(range),'-^k','MarkerIndices',1:10:length(FMT.RCIN.C1(range)));
% legend([ail,elv,rud,thr],{'Aileron','Elevator','Rudder','Throttle'},'location','northwest')
ylabel('Control Request')
axis tight
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

s2 = subplot(3,1,2);
pitch=plot((FMT.IMU.TimeS),FMT.IMU.GyrY,'-b');
ylabel('Pitch Rate q')
axis tight
grid on
box on

s3 = subplot(3,1,3);
hold on
dydx = diff([eps;FMT.IMU.GyrY])./diff([eps;FMT.IMU.TimeS]);
pitchac=plot((FMT.IMU.TimeS),dydx,'-k');
pitcha2c=plot((FMT.IMU.TimeS),smooth(dydx,10,'loess'),'-b');
ylabel('Pitch Accel qdot')
axis tight
grid on
box on
linkaxes([s1,s2,s3],'x');
% xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
clear s1 s2 s3 s4