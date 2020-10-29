function [] = position(INFO,FMT,GND,AVT,fig)
%Plots ground station data
fig.Name = 'Position Plot';
load('Field.mat');
clf(fig)

% GPS X Y
mstruct = defaultm('mercator');
mstruct.origin = [43.9534 -79.3207 0]; % TEMAC LOCATION
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);
[X,Y,Z] = mfwdtran(mstruct,FMT.GPS.Lat,FMT.GPS.Lng,FMT.GPS.Alt);
[X2,Y2,Z2] = mfwdtran(mstruct,FMT.POS.Lat,FMT.POS.Lng,FMT.POS.Alt);
try
    [X3,Y3,Z3] = mfwdtran(mstruct,FMT.GPS2.Lat,FMT.GPS2.Lng,FMT.GPS2.Alt);
catch
end
% [gndX,gndY] = mfwdtran(mstruct,GND.GPS.Lat,GND.GPS.Lon);
[RwyX,RwyY] = mfwdtran(mstruct,Field.Runway(:,2),Field.Runway(:,1));
[LineX,LineY] = mfwdtran(mstruct,Field.Flightline(:,2),Field.Flightline(:,1));
[RoadsX,RoadsY] = mfwdtran(mstruct,Field.Roads(:,2),Field.Roads(:,1));
[TreesX,TreesY] = mfwdtran(mstruct,Field.Treeline(:,2),Field.Treeline(:,1));

try
[cmdX,cmdY,cmdAlt] = mfwdtran(mstruct,FMT.CMD.Lat,FMT.CMD.Lng,FMT.CMD.Alt);
end


%% nsats
s(1) = subplot(2,2,1);

gpsp = plot(FMT.GPS.TimeS,FMT.GPS.NSats,'k');
try
    hold on
    gps2p = plot(FMT.GPS2.TimeS,FMT.GPS2.NSats,'r');
catch
end

grid on
box on

ylabel('Num Sats');
try
legend([gpsp,gps2p],{'GPS1','GPS2'});
catch
    legend([gpsp],{'GPS1'});
end
axis tight

%% hdop
s(2) = subplot(2,2,3);

gpsp = plot(FMT.GPS.TimeS,FMT.GPS.HDop,'k');
try
    hold on
    gps2p = plot(FMT.GPS2.TimeS,FMT.GPS2.HDop,'r');
catch
end

grid on
box on

ylabel('HDop');
try
legend([gpsp,gps2p],{'GPS1','GPS2'});
catch
    legend([gpsp],{'GPS1'});
end
axis tight

%% XYZ 
s2 = subplot(2,2,2);
hold on

pxyz2 = plot3(X2,Y2,Z2,'b');
axis equal
pylim = ylim;
pxlim = xlim;
pzlim = zlim;

pxyz = plot3(X,Y,Z,'k');
try
    pxyz3 = plot3(X3,Y3,Z3,'r');
catch
end
% legend([pxyz,pxyz2],{'GPS1 Pos','EKF Pos'});
% % hold on


try
homeAlt = FMT.ORGN.Alt(find((FMT.ORGN.Alt>0),1,'last'));
plot3(cmdX(cmdAlt~=0),cmdY(cmdAlt~=0),cmdAlt(cmdAlt~=0)+homeAlt,'bd','LineWidth',1.5)
catch
end



    % Draw Runway
  
hold on
plot3(RwyX,RwyY,repmat(homeAlt,length(RwyX)),'-k','Color',[0.2 0.2 0.2]);
plot3(LineX,LineY,repmat(homeAlt,length(LineX)),'--r');
plot3(RoadsX,RoadsY,repmat(homeAlt,length(RoadsX)),'--','Color',[0.5 0.5 0.5]);
plot3(TreesX,TreesY,repmat(homeAlt,length(TreesX)),'--','Color',[0.5 0.5 0.5]);
axis equal





setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera')

axis equal
xlim(pxlim)
ylim(pylim)
zlim(pzlim)

try
    legend([pxyz,pxyz2,pxyz3],{'GPS1 Pos','EKF Pos','GPS2 Pos'});
catch
legend([pxyz,pxyz2],{'GPS1 Pos','EKF Pos'});
end

%%
s(3) = subplot(2,2,4) 
hold on
use = plot(FMT.GPS.TimeS,FMT.GPS.U,'k')

try
    use2 = plot(FMT.GPS2.TimeS,FMT.GPS2.U,'r');
catch
    warning('Only 1 GPS in log file');
end

grid on
box on
axis tight
ylim([-1 2]);
ylabel('Used');


linkaxes([s],'x');








% hold on
% pxy = plot(X,Y,'-k');
% pxy2 = plot(X2,Y2,'-b');
% try 
%     pxy3 = plot(X3,Y3,'-r');
% catch
% end
% 
% axis equal
% pylim = ylim;
% pxlim = xlim;
% % 
% % hold on
% 
% % Draw Ground Station Position
% scatter(mean(gndX),mean(gndY),75,'r*','LineWidth',1.5)
% 
% try
% % Draw Waypoint Locations
% scatter(cmdX,cmdY,50,'bd','LineWidth',1.5)
% end
% 
% % Draw Runway
% plot(RwyX,RwyY,'-k','Color',[0.2 0.2 0.2]);
% plot(LineX,LineY,'--r');
% plot(RoadsX,RoadsY,'--','Color',[0.5 0.5 0.5]);
% plot(TreesX,TreesY,'--','Color',[0.5 0.5 0.5]);
% 
% hold off
% grid on
% % axis equal
% xlim(pxlim);
% ylim(pylim);
% try
%     legend([pxy,pxy2,pxy3],{'GPS1 Pos','EKF Pos','GPS2 Pos'});
% catch
% legend([pxy,pxy2],{'GPS1 Pos','EKF Pos'});
% end




% s1 = subplot(4,1,1);
% hold on
% 
% %press
% pgnd = plot(GND.TimeS,GND.Pressure,'-k');
% palt = plot(FMT.BARO.TimeS,FMT.BARO.Press,'--b');
% pavt = plot(AVT.ADP.TimeS,AVT.ADP.P_STATIC,'--r');
% 
% ylabel('Pressure');
% axis tight
% % datetick('x','HH:MM:SS')
% legend([pgnd,palt,pavt],{'Pressure GND','Pressure Pixhawk','Pressure Aventech'},'location','northwest')
% grid on
% box on
% 
% s2= subplot(4,1,2);
% hold on
% 
% tgnd = plot(GND.TimeS,GND.TempC,'-k');
% tair = plot(FMT.IMU.TimeS,FMT.IMU.Temp,'--b');
% tfast = plot(AVT.ADP.TimeS,AVT.ADP.TempFast,'-.r');
% tavt = plot(AVT.ADP.TimeS,AVT.ADP.Temp,'-r');
% 
% legend([tgnd,tair,tfast,tavt],{'Temp GND','Temp Pixhawk',...
%     'Temp Aventech Fast','Temp Aventech'},'location','northwest')
% ylabel('Temp C')
% axis tight
% % datetick('x','HH:MM:SS')
% axis tight
% grid on
% box on
% 
% s3=subplot(4,1,3);
% hold on
% %wind speed ground
% yyaxis left
% gnd=plot(GND.TimeS(GND.TimeS>min(FMT.WIND.TimeS)),GND.WindSpeed(GND.TimeS>min(FMT.WIND.TimeS)),'-k');
% ylabel('Velocity GND (m/s)');
% ax = gca;
% ax.YColor = 'k';
% yyaxis right
% air=plot(FMT.WIND.TimeS,FMT.WIND.SPD,'--b');
% ylabel('Velocity ALT (m/s)');
% ax = gca;
% ax.YColor = 'b';
% % datetick('x','HH:MM:SS')
% axis tight
% if isempty(gnd)==1 %if there is no gndstation
%     legend([air],{'Wind Speed ALT'},'location','northwest')
% else
%     legend([air,gnd],{'Wind Speed ALT','Wind Speed GND'},'location','northwest')
% end
% grid on
% box on
% 
% s4=subplot(4,1,4);
% hold on
% %wind dir
% gnd=plot(GND.TimeS(GND.TimeS>min(FMT.WIND.TimeS)),GND.WindDirection(GND.TimeS>min(FMT.WIND.TimeS)),'-k');
% air=plot(FMT.WIND.TimeS,FMT.WIND.DIR,'--b');
% ylabel('Wind Direction (deg)')
% if isempty(gnd)==1 %if there is no gndstation
%     legend([air],{'Wind Direction ALT (from)'},'location','northwest')
% else
%     legend([gnd,air],{'Wind Direction GND (from)','Wind Direction ALT (from)'},'location','southwest')
% end
% % datetick('x','HH:MM:SS')
% axis tight
% grid on
% box on
% 
% linkaxes([s1,s2,s3,s4],'x');
% xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
% clear s1 s2 s3 s4