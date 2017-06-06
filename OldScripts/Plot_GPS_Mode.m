function [ INFO ] = Plot_GPS_Mode( FMT, INFO )
%PLOT_GPS_MODE Summary of this function goes here
%   Detailed explanation goes here
load('field');

try
    FltStart = INFO.TimeStart;
    FltEnd = INFO.TimeEnd;
catch
    FltStart = 0;
    FltEnd = inf;
end


MODE = FMT.MODE;
GPS = FMT.GPS;

%
ModeChange = [MODE.TimeUS,MODE.ModeNum]; %Copy mode
ModeChange(:,3) = [diff(MODE.ModeNum);NaN]; %find diff between mode change
ModeChange(:,4) = MODE.LineNo;%mode start line index
ModeChange = ModeChange(ModeChange(:,3)~=0,:);
ModeChange(:,5) = [ModeChange(2:end,4)-1;inf];

FltFilterIdx = ModeChange(:,1)>FltStart&ModeChange(:,1)<FltEnd;

try
    %Try to include one more flight mode change before flight start
    FltFilterIdx(find(FltFilterIdx==1, 1 )-1) = 1;
end

ModeChange = ModeChange(FltFilterIdx,:);% Filter isfly

UniqueMode = unique(ModeChange(:,2));




mstruct = defaultm('mercator');
% mstruct = defaultm('eqaconic');
mstruct.origin = [Field.TEMAC(2) Field.TEMAC(1) 0];
% mstruct.origin = [0 0 0];
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);
%
for i = 1:length(UniqueMode);
    SingleMode = ModeChange(ModeChange(:,2)==UniqueMode(i),:); %filter each mode
    if isempty(SingleMode) ~= 1
        GPS_idx = zeros(length(GPS(:,1)),1);
        for j = 1:length(SingleMode(:,1))
            idx_start = SingleMode(j,4);
            idx_end = SingleMode(j,5);
            GPS_idx = or(GPS_idx, GPS.LineNo>=idx_start&GPS.LineNo<=idx_end);
        end
        
        % This filter points not within flight
        Flt_idx = (GPS.TimeUS>=INFO.TimeStart&GPS.TimeUS<=INFO.TimeEnd);
        
        % AND logic to combine mode and flt filters
        Plot_idx = and(GPS_idx, Flt_idx);
        
        % Convert Lat Lng to Mercator X Y
        [x,y] = mfwdtran(mstruct, GPS.Lat(Plot_idx),GPS.Lng(Plot_idx));
        
        
        hold on
        plot(x,y,'.');
        hold off
        
    end
end
clear x y
ModeString = {'Manual','CIRCLE','STABILIZE','TRAINING','ACRO','FBWA','FBWB','CRUISE','AUTOTUNE',' ','Auto','RTL','Loiter',' ',' ','Guided'};



hold on
[FL_x,FL_y] = mfwdtran(mstruct, Field.Flightline(:,2),Field.Flightline(:,1));
[RWY_x,RWY_y] = mfwdtran(mstruct, Field.Runway(:,2),Field.Runway(:,1));
[RD_x,RD_y] = mfwdtran(mstruct, Field.Roads(:,2),Field.Roads(:,1));
[TL_x,TL_y] = mfwdtran(mstruct, Field.Treeline(:,2),Field.Treeline(:,1));
plot(FL_x,FL_y,'r--');
plot(RWY_x,RWY_y,'k-');
plot(RD_x,RD_y,'k:');
plot(TL_x,TL_y,'k-.');
hold off

UniqueMode
axis equal
legend(ModeString(UniqueMode+1))





INFO.Mode.TimeUS = ModeChange(:,1);
INFO.Mode.TimeFlt = (INFO.Mode.TimeUS - INFO.TimeStart)./1e6;
INFO.Mode.ModeNo = ModeChange(:,2);
INFO.Mode.Mode = ModeString(INFO.Mode.ModeNo+1)';

end

