function [ INFO ] = FMT_GetInfo( INFO,FMT )


INFO.GNDTEST = 0;

% Check if GND Testing + No GPS Lock
if isfield(FMT,'GPS') == 0 
    % GPS disabled / not connected
    FMT.GPS.GWk(1) = 1900;
    FMT.GPS.GMS(1) = FMT.ATT.TimeUS(1)./1000;
    FMT.GPS.GMS(2) = FMT.ATT.TimeUS(end)./1000;
    FMT.STAT.isFlying(:) = 1;
    FMT.STAT.isFlying(1) = 0;
    FMT.STAT.isFlying(end) = 0;
    INFO.GNDTEST = 1; 
    INFO.TIMEUSoffset = 
    
    
    GMT = -4;
    idx = find((FMT.GPS.GWk)~=0);
    idx = idx(1);
    
    
    jd = gps2jd(GWk,GMS./1000);
[yr,mn,dy]=jd2cal(jd);
timestr = datestr(dy+GMT/24,'HH:MM:SS');
MatlabDateNum = datenum(sprintf('%d %d %d %s',yr,mn,dy-rem(dy,1),timestr),'yyyy mm dd HH:MM:SS');
    
    
elseif sum(FMT.GPS.GWk)==0 && sum(FMT.GPS.GMS)==0
    % No GPS Lock
    FMT.GPS.GWk(:) = 1900;
    FMT.GPS.GMS(:) = FMT.GPS.TimeUS(1)./1000;
    FMT.GPS.GMS(end) = FMT.GPS.TimeUS(end)./1000;
    FMT.STAT.isFlying(:) = 1;
    FMT.STAT.isFlying(1) = 0;
    FMT.STAT.isFlying(end) = 0;
    INFO.GNDTEST = 1;
end


% GPS LineNo
LogStart_GPSidx = find(FMT.GPS.GWk>0,1);
LogEnd_GPSidx = find(FMT.GPS.GWk>0, 1, 'last' );

% LogEnd_GPSidx

if INFO.GNDTEST ~= 1
INFO.Time.LogStart = Time_GPS2ML(FMT.GPS.GWk(LogStart_GPSidx),FMT.GPS.GMS(LogStart_GPSidx),FMT.GPS.TimeUS(LogStart_GPSidx).*-1);
% INFO.LineNo.LogStart = FMT.STAT.LineNo(LogStart_GPSidx);
% datestr(INFO.Time.LogStart,'yyyy-mm-dd HH:MM:SS')
INFO.Time.LogEnd = Time_GPS2ML(FMT.GPS.GWk(LogEnd_GPSidx),FMT.GPS.GMS(LogEnd_GPSidx),0);
% INFO.LineNo.LogEnd = FMT.GPS.LineNo(LogEnd_GPSidx);
% datestr(INFO.Time.LogEnd,'yyyy-mm-dd HH:MM:SS')
INFO.Time.LogDuration = duration((INFO.Time.LogEnd - INFO.Time.LogStart)*24,0,0);
INFO.Time.LogDuration.Format = 'mm:ss';
end



%%
% STAT LineNo
FlightStart_STATidx = find(FMT.STAT.isFlying==1, 1 );
FlightEnd_STATidx = find(FMT.STAT.isFlying==1, 1, 'last' );

% Flight Start
INFO.Time.FlightStartSec = FMT.STAT.TimeUS(FlightStart_STATidx)./1e6;
INFO.LineNo.FlightStartSec = FMT.STAT.LineNo(FlightStart_STATidx);

% Flight End
INFO.Time.FlightEndSec = FMT.STAT.TimeUS(FlightEnd_STATidx)./1e6;
INFO.LineNo.FlightEndSec = FMT.STAT.LineNo(FlightEnd_STATidx);

% Flight Duration
INFO.Time.FlightDuration = duration(0,0,(INFO.Time.FlightEndSec - INFO.Time.FlightStartSec));
INFO.Time.FlightDuration.Format = 'mm:ss';

% STAT LineNo
ArmedStart_STATidx = find(FMT.STAT.Armed==1, 1 );
ArmedEnd_STATidx = find(FMT.STAT.Armed==1, 1, 'last' );

% Flight Start
INFO.Time.ArmedStartSec = FMT.STAT.TimeUS(ArmedStart_STATidx)./1e6;
INFO.LineNo.ArmedStartSec = FMT.STAT.LineNo(ArmedStart_STATidx);

% Flight End
INFO.Time.ArmedEndSec = FMT.STAT.TimeUS(ArmedEnd_STATidx)./1e6;
INFO.LineNo.ArmedEndSec = FMT.STAT.LineNo(ArmedEnd_STATidx);

% Flight Duration
INFO.Time.ArmedDuration = duration(0,0,(INFO.Time.ArmedEndSec - INFO.Time.ArmedStartSec));
INFO.Time.ArmedDuration.Format = 'mm:ss';





%% Detect Mode Change
try
    ModeChange = [FMT.MODE.TimeUS,FMT.MODE.ModeNum]; %Copy mode
    ModeChange(:,3) = [diff(FMT.MODE.ModeNum);NaN]; %find diff between mode change
    ModeChange(:,4) = FMT.MODE.LineNo;%mode start line index
    ModeChange = ModeChange(ModeChange(:,3)~=0,:);
    ModeChange(:,5) = [ModeChange(2:end,4)-1;INFO.LineNo.FlightEndSec];
    ModeChange(:,6) = [ModeChange(2:end,1)-1;FMT.STAT.TimeUS(end)];
    
    % Segment Mode StartTimeUS EndTimeUS isArmed isFlying
    Modes = [[1:length(ModeChange(:,1))]',ModeChange(:,[2 1 6])];
catch
    Modes = [1,0,FMT.STAT.TimeUS(1),FMT.STAT.TimeUS(end)];
end

INFO.DebugModes = Modes;

% Split Armed Change
ArmedChangeTimeUS = FMT.STAT.TimeUS(diff(FMT.STAT.Armed)~=0);
Armed = FMT.STAT.Armed(diff(FMT.STAT.Armed)~=0);

for n = 1:length(ArmedChangeTimeUS)
    idx = sum(Modes(:,3)<ArmedChangeTimeUS(n));
    Modes = [Modes(1:idx,:);Modes(idx,:);Modes(idx+1:end,:)];
    Modes(idx,4) = ArmedChangeTimeUS(n);
    Modes(idx+1,3) = ArmedChangeTimeUS(n)+1;
    Modes(idx,5) = rem(Armed(n),2);
    Modes(idx+1:end,5) = rem(Armed(n)+1,2);
end

isFlyingChangeTimeUS = FMT.STAT.TimeUS(diff(FMT.STAT.isFlying)~=0);
isFlying = FMT.STAT.isFlying(diff(FMT.STAT.isFlying)~=0);
for n = 1:length(isFlyingChangeTimeUS)
    idx = sum(Modes(:,3)<isFlyingChangeTimeUS(n));
    Modes = [Modes(1:idx,:);Modes(idx,:);Modes(idx+1:end,:)];
    Modes(idx,4) = isFlyingChangeTimeUS(n);
    Modes(idx+1,3) = isFlyingChangeTimeUS(n)+1;
    Modes(idx,6) = rem(isFlying(n),2);
    Modes(idx+1:end,6) = rem(isFlying(n)+1,2);
end

INFO.Modes.ModesMat = Modes;
% quick fix: if isArmed are ALL ZERO and length()>1, change them to be one
if sum(INFO.Modes.ModesMat(:,5))==0 && length(INFO.Modes.ModesMat(:,5))>1
    INFO.Modes.ModesMat(:,5) = INFO.Modes.ModesMat(:,5).*0+1;
end

ModeStr = {'MANUAL','CIRCLE','STABILIZE','TRAINING','ACRO','FBWA','FBWB','CRUISE','AUTOTUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};
ModeAbbr = {'MANUAL','CIRCLE','STAB','TRAIN','ACRO','FBWA','FBWB','CRUISE','TUNE',' ','AUTO','RTL','LOITER',' ',' ','GUIDED'};

INFO.Modes.ModeStrList = ModeStr;
INFO.Modes.ModeAbbrList = ModeAbbr;


isFlyingStr = {'GROUND','AIRBORNE'};
isArmedStr = {'DISARMED','ARMED'};

INFO.Modes.Segment = Modes(:,1);
INFO.Modes.ModeNo = Modes(:,2);
INFO.Modes.ModeStr = ModeStr(Modes(:,2)+1);
INFO.Modes.ModeAbbr = ModeAbbr(Modes(:,2)+1);
INFO.Modes.ModeStartTimeUS = Modes(:,3);
INFO.Modes.ModeEndTimeUS = Modes(:,4);
INFO.Modes.isArmed = Modes(:,5);
INFO.Modes.isFlying = Modes(:,6);



INFO.Modes.Summary(:,1:2) = num2cell(Modes(:,1:2));
INFO.Modes.Summary(:,3) = INFO.Modes.ModeStr;
INFO.Modes.Summary(:,4:5) = num2cell((Modes(:,3:4)./1e6));
INFO.Modes.Summary(:,6) = isArmedStr(Modes(:,5)+1);
INFO.Modes.Summary(:,7) = isFlyingStr(Modes(:,6)+1);
% ModeChange = ModeChange(ModeChange(:,1)>INFO.TimeStart&ModeChange(:,1)<INFO.TimeEnd,:);% Filter isfly



%% CHECk SYSTEM INOPs
INFO.MSG = [];

% Check BATT INOP
try
    if sum(FMT.CURR.CurrTot) == 0
        INFO = MSG_Add(INFO,'BATT','BATTERY SENSOR INOP');
    end
catch
    INFO = MSG_Add(INFO,'BATT','BATTERY SENSOR NOT AVAIL');
end

% Check Airspeed INOP
try
    if mean(FMT.ARSP.DiffPress) < 1
        INFO = MSG_Add(INFO,'ARSP','AIRSPEED SENSOR INOP');
    end
catch
    INFO = MSG_Add(INFO,'ARSP','AIRSPEED SENSOR NOT AVAIL');
end

% Check GPS INOP
try
    if sum(FMT.GPS.NSats) == 0
        INFO = MSG_Add(INFO,'ARSP','GPS INOP');
    end
catch
    INFO = MSG_Add(INFO,'ARSP','GPS NOT AVAIL');
end



% %
% ModeChange = [FMT.MODE.TimeUS,FMT.MODE.ModeNum]; %Copy mode
% ModeChange(:,3) = [diff(FMT.MODE.ModeNum);NaN]; %find diff between mode change
% ModeChange(:,4) = FMT.MODE.LineNo;%mode start line index
% ModeChange = ModeChange(ModeChange(:,3)~=0,:);
% ModeChange(:,5) = [ModeChange(2:end,4)-1;inf];
%
%
% % ModeChange = ModeChange(ModeChange(:,1)>INFO.TimeStart&ModeChange(:,1)<INFO.TimeEnd,:);% Filter isfly
%
%
% UniqueMode = unique(ModeChange(:,2));



end

