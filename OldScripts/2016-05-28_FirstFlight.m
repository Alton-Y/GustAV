clc
clear

FMT = FMT_Load('2016-05-28 12-36-25.log-1544147.mat');

INFO = INFO_Get(FMT);


clf
[ INFO ] = Plot_GPS_Mode( FMT, INFO );

box on



%% TERRAIN OVERLAY TEST

load Field.mat
load DEM.mat


mstruct = defaultm('mercator');
% mstruct = defaultm('eqaconic');
mstruct.origin = [Field.TEMAC(2) Field.TEMAC(1) 0];
% mstruct.origin = [0 0 0];
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);

hold on


[x,y] = mfwdtran(mstruct, DEM_lat, DEM_lon);

[FL_x,FL_y] = mfwdtran(mstruct, Field.Flightline(:,2),Field.Flightline(:,1));
[RWY_x,RWY_y] = mfwdtran(mstruct, Field.Runway(:,2),Field.Runway(:,1));
[RD_x,RD_y] = mfwdtran(mstruct, Field.Roads(:,2),Field.Roads(:,1));
[TL_x,TL_y] = mfwdtran(mstruct, Field.Treeline(:,2),Field.Treeline(:,1));
plot(FL_x,FL_y,'r--','LineWidth',2);
plot(RWY_x,RWY_y,'k-','LineWidth',2);
plot(RD_x,RD_y,'k:','LineWidth',2);
plot(TL_x,TL_y,'k-.','LineWidth',2);


DEM_X = reshape(x,91,80)';
DEM_Y = reshape(y,91,80)';
DEM_Z = reshape(DEM_z,91,80)';

[C,h] = contour(DEM_X,DEM_Y,DEM_Z,[240:260]);
clabel(C,h)

ylim ([-400 300])
xlim ([-300 800])

hold off
axis equal
