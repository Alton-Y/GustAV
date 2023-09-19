function [INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles)
% This funciton loads the raw .mat files from the pixhawk into the
%corresponding formatted .mat files.

if nargin==2
    load(pixhawkpath);
elseif nargin==3
filename = pixhawkfiles{1};
load(strcat(pixhawkpath,'/',filename));
else
    error('Pixhawk dataflash file location error');
end
varList = sort(Seen);



% Calculate the GPS time offset. If GPS is N/A, offset = 0;
try
    %Timezone
    try
        GMT = INFO.timezone;
    catch
        GMT = 0;
    end
    
    if exist('GPS_0','var') == 1
        GPS = GPS_0;
    else
        GPS = GPS_1;
    end
    LogStart_GPSidx = find(GPS(:,6)>0,1); %GPS(:,5) = FMT.GPS.GWk
    GWk = GPS(LogStart_GPSidx,6);
    GMS = GPS(LogStart_GPSidx,5); %GPS(:,4) = FMT.GPS.GMS;
    GMS = GMS - GPS(LogStart_GPSidx,2)./1e3; %GPS(:,2) = MT.GPS.TimeUS
    
    jd = gps2jd(GWk,GMS./1000);
    [yr,mn,dy]=jd2cal(jd);
    timestr = datestr(dy+GMT/24,'HH:MM:SS');
    pixhawkstart = datenum(sprintf('%d %d %d %s',yr,mn,dy-rem(dy,1),timestr),'yyyy mm dd HH:MM:SS');
catch
    pixhawkstart = 0;
end


INFO.pixhawkstart = pixhawkstart;




FMT.Seen = Seen;
FMT.PARM = PARM;

%sometimes it is loaded as CESC_2 but we want CESC
% if exist('CESC_2','var') == 1
%     CESC = CESC_2;
% end
    
for i = 1:length(varList)
    %     if exist(varList{i}) == 1 % check if label exists but main array doesn't
%     try
        % eg: label = AHR2_label
        eval(sprintf('label = %s_label;',varList{i}));
        
        for j = 1:length(label)
            % eg: FMT.AHR2.LineNo = AHR2(:,1)
            spaceidx = isspace(label{j}); %remove spaces
            label{j}=label{j}(spaceidx ==0);
            
%             vars = who
%             TF = ((strfind(vars, sprintf('%s',varList{i}),'ForceCellOutput',1)));
%             TF = (not(cellfun('isempty',TF)))
%             TF2 = (contains(vars,'_label'));
%             instances = vars(TF & ~TF2)
%CAND will need special attention
            
            
            if exist(sprintf('%s',varList{i}))
                %AP4 and earlier, and some params in 4.1 that don't have multiples
                try
                eval(sprintf('FMT.%s(:,1).%s = %s(:,%i);',varList{i},label{j},varList{i},j));
                end
%                 eval(sprintf('clear %s;',varList{i}));
            elseif exist(sprintf('%s_0',varList{i}))
                %AP4.1 and later
                eval(sprintf('FMT.%s(:,1).%s = %s_0(:,%i);',varList{i},label{j},varList{i},j));
%                 eval(sprintf('clear %s;',varList{i}));
            else
                %sometimes there is only one sensor instance with a super
                %high ID (CAN NodeID)
                try
                eval(sprintf('FMT.%s(:,1).%s = %s_125(:,%i);',varList{i},label{j},varList{i},j));
                catch
                end
                try
                eval(sprintf('FMT.%s(:,1).%s = %s_112(:,%i);',varList{i},label{j},varList{i},j));
                catch
                end
                try
                eval(sprintf('FMT.%s(:,1).%s = %s_122(:,%i);',varList{i},label{j},varList{i},j));
                catch
                end
                try
                eval(sprintf('FMT.%s(:,1).%s = %s_124(:,%i);',varList{i},label{j},varList{i},j));
                catch
                end
                    
            end
            
            %check if there are more instances of this sensor, up to 5
            if exist(sprintf('%s_1',varList{i}))
                eval(sprintf('FMT.%s(:,2).%s = %s_1(:,%i);',varList{i},label{j},varList{i},j));
            end
            if exist(sprintf('%s_2',varList{i}))
                eval(sprintf('FMT.%s(:,3).%s = %s_2(:,%i);',varList{i},label{j},varList{i},j));
            end
            if exist(sprintf('%s_3',varList{i}))
                eval(sprintf('FMT.%s(:,4).%s = %s_3(:,%i);',varList{i},label{j},varList{i},j));
            end
            if exist(sprintf('%s_4',varList{i}))
                eval(sprintf('FMT.%s(:,5).%s = %s_4(:,%i);',varList{i},label{j},varList{i},j));
            end
            

%         eval(sprintf('clear %s_label;',varList{i})); %probably slow
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
        
       
        
        try
            for kk = 1:size(FMT.(varList{i}),2)
                try
                FMT.(varList{i})(:,kk).TimeS(:,1) = [FMT.(varList{i})(:,kk).TimeUS]./1e6;
                FMT.(varList{i})(:,kk).TimeLOCAL = pixhawkstart+[FMT.(varList{i})(:,kk).TimeS]./86400;
                catch
                end
            end
        end
%     end
end


% Writing derived wind direction and speed into FMT.WIND
try
    if isfield(FMT,'NKF7')
        NKF7 = FMT.NKF7;
    elseif isfield(FMT,'XKF2')
        NKF7 = FMT.XKF2(:,1);
    end
    FMT.WIND.VWE = NKF7.VWE;
    FMT.WIND.VWN = NKF7.VWN;
    FMT.WIND.SPD = ([NKF7.VWE].^2+[NKF7.VWN].^2).^0.5;
    FMT.WIND.DIR = rem(90-atan2d([NKF7.VWN],[NKF7.VWE])+180,360);
    FMT.WIND.TimeS = NKF7.TimeS;
    FMT.WIND.TimeLOCAL = NKF7.TimeLOCAL;
    

        
catch
    warning('Unable to create FMT.WIND');
end

% Add MAVLINK messages sent
try   
    for count = 1:size(MSG1,2)        
        FMT.MSG.MessageStr(count,1)= string(MSG1{count}(3));
    end
catch
    warning('Unable to read MAVLINK messages');
end
end