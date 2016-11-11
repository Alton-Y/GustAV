function [ TrimData, TrimTimeS ] = Data_Trim( FMT, INFO, ParamGroup, ParamName, Segment, isArmed, isFlying )
%DATA_TRIM Summary of this function goes here
%   Detailed explanation goes here

TimeUS = FMT.(ParamGroup).TimeUS;

if Segment == 0
    Segment = 1:max(INFO.Modes.Segment);
end
% sum allows input segment be an array;
TrimIdx = sum((INFO.Modes.Segment>=Segment(1) & INFO.Modes.Segment<=Segment(end) & INFO.Modes.isArmed==isArmed & INFO.Modes.isFlying==isFlying),2);

% ensure continuity of the plot
TrimStartIdx = find(TrimIdx==1, 1 );
TrimEndIdx = find(TrimIdx==1, 1, 'last' );

TrimStartTimeUS = INFO.Modes.ModeStartTimeUS(TrimStartIdx);
TrimEndTimeUS = INFO.Modes.ModeEndTimeUS(TrimEndIdx);

TimeUSidx = (TimeUS>TrimStartTimeUS & TimeUS<TrimEndTimeUS);

TrimTimeS = TimeUS(TimeUSidx)./1e6;
TrimData = FMT.(ParamGroup).(ParamName)(TimeUS>TrimStartTimeUS & TimeUS<TrimEndTimeUS);

end

