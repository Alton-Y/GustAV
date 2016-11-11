function [INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles)
% This funciton loads the raw .mat files from the pixhawk into the
%corresponding formatted .mat files.
filename = pixhawkfiles{1};
load(strcat('./',pixhawkpath,'/',filename));
varList = Seen;



% Calculate the GPS time offset. If GPS is N/A, offset = 0;
try
    %Timezone
    try
        GMT = INFO.timezone;
    catch
        GMT = 0;
    end
    
    LogStart_GPSidx = find(GPS(:,5)>0,1); %GPS(:,5) = FMT.GPS.GWk
    GWk = GPS(LogStart_GPSidx,5);
    GMS = GPS(LogStart_GPSidx,4); %GPS(:,4) = FMT.GPS.GMS;
    GMS = GMS - GPS(LogStart_GPSidx,2)./1e3; %GPS(:,2) = MT.GPS.TimeUS
    
    jd = gps2jd(GWk,GMS./1000);
    [yr,mn,dy]=jd2cal(jd);
    timestr = datestr(dy+GMT/24,'HH:MM:SS');
    pixhawkstart = datenum(sprintf('%d %d %d %s',yr,mn,dy-rem(dy,1),timestr),'yyyy mm dd HH:MM:SS');
catch
    pixhawkstart = 0;
end


INFO.pixhawkstart = pixhawkstart;


for i = 1:length(varList)
    %     if exist(varList{i}) == 1 % check if label exists but main array doesn't
    try
        % eg: label = AHR2_label
        eval(sprintf('label = %s_label;',varList{i}));
        
        for j = 1:length(label)
            % eg: FMT.AHR2.LineNo = AHR2(:,1)
            eval(sprintf('FMT.%s.%s = %s(:,%i);',varList{i},label{j},varList{i},j));
        end
        
        % honesly i don't remember what this catch command does.
        %     catch
        %         try
        %             % eg: FMT.PARM = PARM
        %             eval(sprintf('FMT.%s = %s;',varList{i},varList{i}));
        %         catch
        %             eval(sprintf('disp(%s);',varList{i}));
        %         end
        %     end
        
        
        % eg: clear AHR2_label
        eval(sprintf('clear %s;',varList{i}));
        eval(sprintf('clear %s_label;',varList{i}));
        
        try
            FMT.(varList{i}).TimeS = [FMT.(varList{i}).TimeUS]./1e6;
            FMT.(varList{i}).TimeLOCAL = pixhawkstart+[FMT.(varList{i}).TimeS]./86400;
        end      
    end
    
    FMT.Seen = Seen;
    FMT.PARM = PARM;
    
    try
        FMT.WIND.VWE = FMT.NKF7.VWE;
        FMT.WIND.VWN = FMT.NKF7.VWN;
        FMT.WIND.SPD = ([FMT.NKF7.VWE].^2+[FMT.NKF7.VWN].^2).^0.5;
        FMT.WIND.DIR = rem(90-atan2d([FMT.NKF7.VWN],[FMT.NKF7.VWE])+180,360); 
    end
    
    
    
    
    
end