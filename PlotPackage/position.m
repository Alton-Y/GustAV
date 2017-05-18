% figure
load('Field.mat');


SYNCFMT.GPS.Lat(SYNCFMT.GPS.Lat == 0) = nan;
SYNCFMT.GPS.Lng(SYNCFMT.GPS.Lng == 0) = nan;


% GPS X Y
mstruct = defaultm('mercator');
mstruct.origin = [43.9534 -79.3207 0]; % TEMAC LOCATION
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);
[X,Y] = mfwdtran(mstruct,SYNCFMT.GPS.Lat,SYNCFMT.GPS.Lng);

[gndX,gndY] = mfwdtran(mstruct,GND.GPS.Lat,GND.GPS.Lon);
[RwyX,RwyY] = mfwdtran(mstruct,Field.Runway(:,2),Field.Runway(:,1));
[LineX,LineY] = mfwdtran(mstruct,Field.Flightline(:,2),Field.Flightline(:,1));
[RoadsX,RoadsY] = mfwdtran(mstruct,Field.Roads(:,2),Field.Roads(:,1));
[TreesX,TreesY] = mfwdtran(mstruct,Field.Treeline(:,2),Field.Treeline(:,1));


[cmdX,cmdY] = mfwdtran(mstruct,FMT.CMD.Lat,FMT.CMD.Lng);


% pxy = plot(X,Y,'-k');
axis equal
xlabel('Distance East [m]');
ylabel('Distance North [m]');
pylim = ylim;
pxlim = xlim;
% 
clf
% hold on
idx = 
scatter3(X,Y,SYNCFMT.BARO.Alt,[],SYNCFMT.WIND.SPD,'.')
colorbar
% caxis([0 360])

% % Draw Ground Station Position
% scatter(mean(gndX),mean(gndY),75,'r*','LineWidth',1.5)
% 
% % Draw Waypoint Locations
% scatter(cmdX,cmdY,50,'bd','LineWidth',1.5)
% 
% 
% scatter(mean(gndX),mean(gndY),75,'r*','LineWidth',1.5)

% % Draw Runway
% plot3(RwyX,RwyY,RwyY*0,'-k','Color',[0.2 0.2 0.2]);
% plot3(LineX,LineY,LineY*0,'--r');
% plot3(RoadsX,RoadsY,RoadsY*0,'--','Color',[0.5 0.5 0.5]);
% plot3(TreesX,TreesY,TreesY*0,'--','Color',[0.5 0.5 0.5]);
% 
% hold off
grid on
axis equal
grid minor
% % axis equal
% xlim(pxlim);
% ylim(pylim);
