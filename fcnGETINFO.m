function [ INFO ] = fcnGETINFO( INFO, FMT )
%FCNGETINFO Summary of this function goes here
%   Detailed explanation goes here

if isfield(FMT,'GPS') == 0
    % No GPS DATA FOUND
    INFO.statusGPS = -1;
    fprintf('GPS: NOT FOUND\n');
elseif sum(FMT.GPS.GWk)==0 && sum(FMT.GPS.GMS)==0
    INFO.statusGPS = 0;
    fprintf('GPS: NO LOCK\n');
else
    INFO.statusGPS = 1;
    fprintf('GPS: OK\n');
end


% start old code
    ModeChange = [FMT.MODE.TimeS,FMT.MODE.ModeNum]; %Copy mode
    ModeChange(:,3) = [diff(FMT.MODE.ModeNum);NaN]; %find diff between mode change
    ModeChange(:,4) = FMT.MODE.LineNo;%mode start line index
    ModeChange = ModeChange(ModeChange(:,3)~=0,:);
%     ModeChange(:,5) = [ModeChange(2:end,4)-1;nan];
    ModeChange(:,6) = [ModeChange(2:end,1)-1;FMT.STAT.TimeS(end)];
    % Segment Mode StartTimeUS EndTimeUS isArmed isFlying
    Modes = [[1:length(ModeChange(:,1))]',ModeChange(:,[2 1 6])];
% end old code

ModeStr = {'MANUAL','CIRCLE','STABILIZE','TRAINING','ACRO','FBWA','FBWB','CRUISE','AUTOTUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};
ModeAbbr = {'MANUAL','CIRCLE','STAB','TRAIN','ACRO','FBWA','FBWB','CRUISE','TUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};


INFO.segments.mode = Modes(:,2);
INFO.segments.modeStr = ModeStr(Modes(:,2)+1)';
INFO.segments.modeAbbr = ModeAbbr(Modes(:,2)+1)';

INFO.segments.startTimeS = Modes(:,3);
INFO.segments.endTimeS = Modes(:,4);
INFO.segments.startTimeLOCAL = INFO.pixhawkstart+Modes(:,3)./86400;
INFO.segments.endTimeLOCAL = INFO.pixhawkstart+Modes(:,4)./86400;



end

