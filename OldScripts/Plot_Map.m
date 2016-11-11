FMT = FMT_Load('2016-06-04 13-36-47.log-1316374.mat');

load('field');
mstruct = defaultm('mercator');
% mstruct = defaultm('eqaconic');
mstruct.origin = [Field.TEMAC(2) Field.TEMAC(1) 0];
% mstruct.origin = [0 0 0];
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);






[x,y] = mfwdtran(mstruct, FMT.GPS.Lat, FMT.GPS.Lng);
clf

% Plot_Format( gca )

Lat = FMT.GPS.Lat;
Lng = FMT.GPS.Lng;

Lat(abs(x)>500) = NaN;
axesm
plotm(Lat,Lng,'.-');
% plot3(x,y,FMT.GPS.Alt,'.-');


