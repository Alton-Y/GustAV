% clc
% clear
% clf
%
% INFO.Date = '2016-06-11';
% INFO.Flight = 3;
% INFO.Aircraft = 'Bix 3';
% PLOT.Segment = 0;
% PLOT.isArmed = 1;
% PLOT.isFlying = 1;
%
% FMT = FMT_Load(sprintf('logs/%s_Flight%i.mat',INFO.Date,INFO.Flight));
%
%
%
function [] = Plot_FlightOverview(INFO,PLOT,FMT)


Plot_Off;
[ PLOT.MSG ] = MSG_Filter( INFO, {'ALL'} );

PLOT.Title = 'FLIGHT OVERVIEW';


%set figure window
set(gcf, 'Position', [200 200 1100 650])

%
[ Alt, TimeBARO ] = Data_Trim(FMT,INFO,'BARO','Alt',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ GS, TimeGPS ] = Data_Trim(FMT,INFO,'GPS','Spd',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ GPSAlt, ~ ] = Data_Trim(FMT,INFO,'GPS','Alt',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);

% [ GPSRAlt, ~ ] = Data_Trim(FMT,INFO,'GPS','RAlt',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ GPSRAlt, ~ ] = Data_Trim(FMT,INFO,'TERR','CHeight',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ Lat, ~ ] = Data_Trim(FMT,INFO,'GPS','Lat',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ Lng, ~ ] = Data_Trim(FMT,INFO,'GPS','Lng',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ ARSP, TimeARSP ] = Data_Trim(FMT,INFO,'ARSP','Airspeed',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
HomeAlt = GPSAlt(1)-GPSRAlt(1);


% set(gcf,'GraphicsSmoothing','on')

set(gcf,'Color',[1 1 1]);

ax1=subplot(3,2,1);
Plot_Format(gca);
plot(TimeGPS,GS,TimeARSP,ARSP);
ylabel('SPEED [m/s]');
xlabel('TIME [s]');
legend('GND SPEED','AIRSPEED','location','southwest');

ax2=subplot(3,2,3);
Plot_Format(gca);
plot(TimeBARO, Alt+HomeAlt);
ylabel('ALTITUDE ASL [m]');
xlabel('TIME [s]');
AGLylim = ylim;

yyaxis right
ylim(AGLylim-HomeAlt);
ylabel('ALTITUDE AGL [m]');
set(gca,'YColor',[0 0 0]);


%%
ax3=subplot(3,2,5);

Plot_Format(gca);
hold on
modePos = get(gca,'Position');
xlabel('TIME [s]');

if PLOT.Segment == 0
    Segments = 1:max(INFO.Modes.Segment);
end
TrimIdx = sum((INFO.Modes.Segment>=Segments(1) & INFO.Modes.Segment<=Segments(end) & INFO.Modes.isArmed==PLOT.isArmed & INFO.Modes.isFlying==PLOT.isFlying),2);

Modes = INFO.Modes.ModesMat(find(TrimIdx>0, 1 ):find(TrimIdx>0, 1, 'last' ),:);
UniqueMode = unique(Modes(:,2));


% n = 3, h = 0.3



for n=1:length(UniqueMode)
    % mode bar height
    if length(UniqueMode) > 4
        h = 0.3;
    else
        h = length(UniqueMode)/15;
    end
    
    
    
    ModeNo = UniqueMode(n);
    idx = (Modes(:,2)==ModeNo);
    ModesMat = Modes(idx,:);
    

    
    for m=1:length(ModesMat(:,1))
        m1 =  ModesMat(m,3)./1e6;
        m2 =  ModesMat(m,4)./1e6;
        n1 = n+h;
        n2 = n-h;
        v = [m1 n1; m2 n1; m2 n2; m1 n2];
        f = [1 2 3 4];
        if ModesMat(m,6) == 1 && ModesMat(m,5) == 1
%             ModesMat(m,:)
%             disp('black')
            patch('Faces',f,'Vertices',v,'FaceColor',[0 0 0]);
        elseif ModesMat(m,5) == 1
%             ModesMat(m,:)
%             disp('gray')
            patch('Faces',f,'Vertices',v,'FaceColor',0.5+[0 0 0]);
        elseif ModesMat(m,5) == 0
%             ModesMat(m,:)
%             disp('white')
            patch('Faces',f,'Vertices',v,'FaceColor',1+[0 0 0]);
        end
    end
end



UniqueSegment = unique(Modes(:,1));
for j = 1:length(UniqueSegment)
    s = UniqueSegment(j);
    idx = Modes(:,1)==s;
    k1 = min(Modes(idx,3))/1e6;
    k2 = max(Modes(idx,4))/1e6;
    
    % segment text
    text((k1+k2)/2,-0.15,sprintf('%i',s),...
        'HorizontalAlignment','Center',...
        'FontName','Agency FB',...
        'FontSize',10,...
        'FontSmoothing','off');
    
    % draw segment buckets
    line([k1 k2],[0.2 0.2]);
    line([k1 k1],[0.3 0.1]);
    line([k2 k2],[0.3 0.1]);
    
    
end




hold off
ylim([-.5 length(UniqueMode)+0.5]);
set(gca,'YTick',1:length(UniqueMode));
set(gca,'YtickLabel',INFO.Modes.ModeStrList(UniqueMode+1))







%% Prep GEO
load('field');
mstruct = defaultm('mercator');
mstruct.origin = [Field.TEMAC(2) Field.TEMAC(1) 0];
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




%%
subplot(3,2,6);
Plot_Format(gca);
mesh(DEM_X,DEM_Y,DEM_Z);
colormap([0 0 0; 1 1 1])
% [C,h] = contour(DEM_X,DEM_Y,DEM_Z,[240:260]);
% clabel(C,h)
plot3(x,y,GPSAlt);
hold on
% START AND END POINT
scatter3(x(1),y(1),GPSAlt(1),'ko');
scatter3(x(end),y(end),GPSAlt(end),'kx');
hold off

xlim([-100 400]);


axis equal
view(0,0)

pbaspect([1.0000    10    0.3235]);
zlabel('ALTITUDE ASL [m]');
% set(gca,'XTickLabel','');
set(gca,'ZGrid','on');
set(gca,'ZMinorGrid','on');
xlabel('VIEW FROM SOUTH');

% save current limits for later
sideviewxlim = xlim;
sideviewzlim = zlim;


% shift z axis limit to push ground terrain to bottom
GroundZ = 240;
deltaZ = GroundZ-sideviewzlim(1);
zlim(sideviewzlim+deltaZ);
xlim(sideviewxlim);

set(gca,'YMinorGrid','off');
set(gca,'XMinorGrid','off');



%
subplot(3,2,[2,4]);
Plot_Format(gca);
plot(x,y);


hold on
% START AND END POINT
scatter(x(1),y(1),'ko');
scatter(x(end),y(end),'kx');

% get current limit for later
mapxlim = xlim;
mapylim = ylim;

%
% gray color
gc = 0.7.*[1,1,1];


[FL_x,FL_y] = mfwdtran(mstruct, Field.Flightline(:,2),Field.Flightline(:,1));
[RWY_x,RWY_y] = mfwdtran(mstruct, Field.Runway(:,2),Field.Runway(:,1));
[RD_x,RD_y] = mfwdtran(mstruct, Field.Roads(:,2),Field.Roads(:,1));
[TL_x,TL_y] = mfwdtran(mstruct, Field.Treeline(:,2),Field.Treeline(:,1));
plot(FL_x,FL_y,'k--','Color',gc);
plot(RWY_x,RWY_y,'k-','Color',gc);
plot(RD_x,RD_y,'k:','Color',gc);
plot(TL_x,TL_y,'k-.','Color',gc);

xlim(mapxlim);
ylim(mapylim);

hold off



pbaspect([1.0000  0.7729  0.7729]);


% axis equal
xlim(sideviewxlim);


xlabel('DISTANCE EAST [m]');
ylabel('DISTANCE NORTH [m]');

set(gca,'YMinorGrid','off');
set(gca,'XMinorGrid','off');
% set(gca,'OuterPosition',[0.526417195896803,0.323079989316174,0.417499899665862,0.646293876382556]);
pbaspect([1.0000  0.7729  0.7729]);

axis equal
mapPos = get(gca,'Position');


subplot(3,2,6);
sidePos = get(gca,'Position');
sidezlim = zlim;
% sidePos(4) = mapPos(4);
%[left bottom width height]
set(gca,'Position',[mapPos(1) modePos(2) mapPos(3) modePos(4)]);
pos = get(gca,'Position');



linkaxes([ax1,ax2,ax3],'x')






Plot_Create(INFO,PLOT,'FlightOverview');
close all


Plot_On;




end