function [MatlabDateNum] = Time_GPS2ML(GWk,GMS,offsetMS)
% , MatlabDateStr, MatlabTimeStr
GMS = GMS+offsetMS./1e3;
GMT = -4;
jd = gps2jd(GWk,GMS./1000);
[yr,mn,dy]=jd2cal(jd);
timestr = datestr(dy+GMT/24,'HH:MM:SS');
MatlabDateNum = datenum(sprintf('%d %d %d %s',yr,mn,dy-rem(dy,1),timestr),'yyyy mm dd HH:MM:SS');

% MatlabDateStr = datestr(MatlabDateNum,'yyyy-mm-dd');
% MatlabTimeStr = datestr(MatlabDateNum,'HH:MM:SS');



end