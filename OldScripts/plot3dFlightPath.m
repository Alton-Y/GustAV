clc
clear
clf

INFO.Date = '2016-06-04';
INFO.Flight = 1;
INFO.Aircraft = 'Bix 3';

FMT = FMT_Load('logs/Bix3/2016-06-04_Flight1.mat');
% FMT = FMT_Load(sprintf('logs/%s_Flight%i.mat',INFO.Date,INFO.Flight));
INFO = FMT_GetInfo(INFO,FMT);


PLOT.Segment = 0;
PLOT.isArmed = 1;
PLOT.isFlying = 1;
PLOT.Title = '3D FLIGHT PATH';



%
[ Alt, TimeBARO ] = Data_Trim(FMT,INFO,'BARO','Alt',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ GS, TimeGPS ] = Data_Trim(FMT,INFO,'GPS','Spd',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ GPSAlt, ~ ] = Data_Trim(FMT,INFO,'GPS','Alt',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ Lat, ~ ] = Data_Trim(FMT,INFO,'GPS','Lat',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ Lng, ~ ] = Data_Trim(FMT,INFO,'GPS','Lng',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ ARSP, TimeARSP ] = Data_Trim(FMT,INFO,'ARSP','Airspeed',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);





Plot_Format(gca);



load('field');
mstruct = defaultm('mercator');
% mstruct = defaultm('eqaconic');
mstruct.origin = [Field.TEMAC(2) Field.TEMAC(1) 0];
% mstruct.origin = [0 0 0];
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);
[x,y] = mfwdtran(mstruct, Lat, Lng);

load('DEM');
[DEM_x,DEM_y] = mfwdtran(mstruct, DEM_lat, DEM_lon);
DEM_X = reshape(DEM_x,91,80)';
DEM_Y = reshape(DEM_y,91,80)';
DEM_Z = reshape(DEM_z,91,80)';

DEM_idx1 = 15:35;
DEM_idx2 = 45:80;

% Trim DEM
DEM_X = DEM_X(DEM_idx1,DEM_idx2);
DEM_Y = DEM_Y(DEM_idx1,DEM_idx2);
DEM_Z = DEM_Z(DEM_idx1,DEM_idx2);


% mesh(DEM_4X,DEM_Y,DEM_Z);
% colormap gray
% [C,h] = contour(DEM_X,DEM_Y,DEM_Z,[240:260]);
% clabel(C,h)


gc = 0.2.*[1,1,1];


[FL_x,FL_y] = mfwdtran(mstruct, Field.Flightline(:,2),Field.Flightline(:,1));
[RWY_x,RWY_y] = mfwdtran(mstruct, Field.Runway(:,2),Field.Runway(:,1));
[RD_x,RD_y] = mfwdtran(mstruct, Field.Roads(:,2),Field.Roads(:,1));
[TL_x,TL_y] = mfwdtran(mstruct, Field.Treeline(:,2),Field.Treeline(:,1));
plot3(FL_x,FL_y,FL_y.*0+242,'k--','Color',gc);
plot3(RWY_x,RWY_y,RWY_y.*0+242,'k-','Color',gc);
plot3(RD_x,RD_y,RD_y.*0+242,'k:','Color',gc);
plot3(TL_x,TL_y,TL_y.*0+242,'k-.','Color',gc);



plot3(x,y,GPSAlt);
axis equal
xlim([-150 500]);
ylim([-250 300]);
zlim([220 360]);


xlabel('Distance East [m]');
ylabel('Distance North [m]');
zlabel('Height ASL [m]');

grid on
