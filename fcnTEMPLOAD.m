function TEMPLOG = fcnTEMPLOAD(INFO,temploggerpath,templogfiles)

%This funciton loads the CSV data from the weather station into the
%corresponding .mat files.
rawCSV = [];


% leapSecs = 17;
leapSecs = 18;

listing = templogfiles;
fprintf('Loading %i TEMPERATURE LOGGER CSV Files.\n',length(templogfiles));


for num = 1:length(listing)
    
    filename = strcat(temploggerpath,'/',listing{num});
    
    try
        M = readmatrix(filename,'NumHeaderLines',1');
        N = zeros(length(M(:,1)),1)+num;
        fprintf('%s\n',listing{num});
    catch
        M = [];
        N = [];
        warning(sprintf('Unable to load %s',listing{num}));
    end
    
    if isempty(rawCSV) == 1;
        rawCSV = M;
        LogNo = N;
    else
        rawCSV = [rawCSV;M];
        LogNo = [LogNo;N];
    end
end

% if version ~= 3
%     %% Filtering Data with No GPS Lock
%     Year = rawCSV(:,6);
%     idx = Year ~= 0 & Year < 20;
%     % Allocate imported array to column variable names
%
%
%     if version == 1
%         Month = rawCSV(idx, 4);
%         Day = rawCSV(idx, 5);
%         Year = rawCSV(idx, 6);
%         Hour = rawCSV(idx, 7);
%         Minute = rawCSV(idx, 8);
%         Second = rawCSV(idx, 9);
%         Millisecond = rawCSV(idx, 10);
%         LattitudeDeg = rawCSV(idx, 1);
%         LongitudeDeg = rawCSV(idx, 2);
%         Altitude = rawCSV(idx, 3);
%         Humidity = rawCSV(idx, 11);
%         Temp = rawCSV(idx, 12);
%         Pressure = rawCSV(idx, 13);
%         WindSpeed = rawCSV(idx, 14);
%         WindDirection = rawCSV(idx, 15);
%         TimeLOCAL = datenum(Year+2000,Month,Day,Hour+INFO.timezone,Minute,Second+Millisecond./1000);
%
%
%     elseif version == 2
%         LattitudeDeg = rawCSV(idx, 1);
%         LongitudeDeg = rawCSV(idx, 2);
%         Altitude = rawCSV(idx, 3);
%         Month = rawCSV(idx, 4);
%         Day = rawCSV(idx, 5);
%         Year = rawCSV(idx, 6);
%         Hour = rawCSV(idx, 7);
%         Minute = rawCSV(idx, 8);
%         Second = rawCSV(idx, 9);
%         Millisecond = rawCSV(idx, 10);
%         Humidity = rawCSV(idx, 11);
%         Temp = rawCSV(idx, 12);
%         Pressure = rawCSV(idx, 13);
%         WindSpeed = rawCSV(idx, 14);
%         WindDirection = rawCSV(idx, 15);
%         TimeMS = rawCSV(idx, 16);
%         LogNo = LogNo(idx, :);
%
%
%         % NaN Handling
%         Pressure = Pressure./10;
%         WindSpeed(WindSpeed < 0) = nan;
%         Pressure(Pressure < 100) = nan;
%         WindDirection(WindDirection == 0) = nan;
%         %% Find TimeLOCAL with TimeMS
%         for num = 1:length(listing)
%             idx2 = (LogNo==num);
%             I = find(idx2==1,1);
%             FirstTimeLOCAL = datenum(Year(I)+2000,Month(I),Day(I),Hour(I)+INFO.timezone,Minute(I),Second(I)+Millisecond(I)./1000);
%             Offset = FirstTimeLOCAL - TimeMS(I)./1000./86400;
%             TimeLOCAL(idx2) = TimeMS(idx2)./1000./86400 + Offset;
%         end
%
%
%
%
%     end
%
%
%     TEMP.TimeLOCAL = TimeLOCAL;
%     TEMP.TimeS = (TimeLOCAL - INFO.pixhawkstart).*24.*3600;
%     TEMP.Humidity = Humidity;
%     TEMP.TempC = Temp;
%     TEMP.TempF = convtemp(Temp, 'C','F') ;
%     TEMP.Pressure = Pressure;
%     TEMP.WindSpeed = WindSpeed;
%     TEMP.WindDirection = WindDirection;
%     try
%         TEMP.TimeMS = TimeMS;
%     end
%
%
%
% else %if version is 3 - Since APR 2017




% % GPS data
% % if age is not empty, the row contains valid GPS data
% idxGPS = rawCSV(:,12)~=0;
% age = rawCSV(idxGPS,12);
% Year = rawCSV(idxGPS,13);
% Month = rawCSV(idxGPS,14);
% Day = rawCSV(idxGPS,15);
% Hour = rawCSV(idxGPS,16);
% Minute = rawCSV(idxGPS,17);
% Second = rawCSV(idxGPS,18);
% HundredthSecond = rawCSV(idxGPS,19);
% GPSBoardTime = rawCSV(idxGPS,1);
% GPSSatTime = datenum(Year,Month,Day,Hour+INFO.timezone,Minute,Second+HundredthSecond./100+age./1000);
% 
% dBoardTime = diff(GPSBoardTime)./1000;
% dSatTime = diff(GPSSatTime).*86400;
% 
% if max(abs(dBoardTime-dSatTime)) > 1
%     disp('GPS Time Sync Error');
% end
% 
% SyncBoardTime = GPSBoardTime(1);
% SyncSatTime = GPSSatTime(1);
% 
% %     plot([GPStimeMS(1:end-1),GPStimeMS(1:end-1)],[dMS,dDatenum]);
% 
% 
% 
% 
% % Filter Invalid Values
% % Negative or Zero Wind Speed
% idxW = rawCSV(:,3) >= 0;
% % tempf = exactly 32.00
% idxT = rawCSV(:,5) ~= 32.0;
% % Negative or Zero Pressure
% idxP = rawCSV(:,6) > 0;
% % Combine filters
% idx = and(and(idxW,idxT),idxP);

% Humidity = rawCSV(idx,4);
% Temp = convtemp(rawCSV(idx,5), 'F','C');
% Pressure = rawCSV(idx,6);
% WindSpeed = rawCSV(idx,3);
% WindDirection = rawCSV(idx,2);


disp('Arduino Onboard Temp log')

locations = ["28E94C04090000E9",...    
    "288F600409000041",...
    "288A890409000083",...
    "2867630409000087"];

names= ["Right Wing LE",...   
    "Nose",...
    "Battery Pack Right Wing",...
    "Battery Pack Left Wing"];

%     get temp sensors
fid = fopen(filename);
varNames = strsplit(fgetl(fid), ',');
fclose(fid);



TimeMS = rawCSV(:,1);

offset = 5000;%218000; %offset between pixhawk start and arduino start in ms
TimeLOCAL = (TimeMS - offset)./1000./86400+ +INFO.pixhawkstart; %assume the logger was started when the pixhawk was started

TEMPLOG.TimeLOCAL = TimeLOCAL;
TEMPLOG.TimeS = (TEMPLOG.TimeLOCAL - INFO.pixhawkstart).*24.*3600;

for count = 1:size(locations,2)       
        TEMPLOG.Loc(1,count)= string(varNames(count+1));
        TEMPLOG.Name(1,count) = names(locations== TEMPLOG.Loc(1,count));
end
    

TEMPLOG.TempC = rawCSV(:,2:size(TEMPLOG.Loc,2)+1);
TEMPLOG.TempF = convtemp(TEMPLOG.TempC, 'C','F') ;
%
TEMPLOG.MPPT.VOLT = rawCSV(:,12)./1000;
TEMPLOG.MPPT.CURR = rawCSV(:,13)./1000;
TEMPLOG.MPPT.VPV = rawCSV(:,14)./1000;
TEMPLOG.MPPT.PPV = rawCSV(:,15)./100;
TEMPLOG.MPPT.TEMPC = rawCSV(:,16)./100;

TEMPLOG.CELL = rawCSV(:,6:11);

TEMPLOG.CELLNAME = string(['CELL1';'CELL2';'CELL3';'CELL4';'CELL5';'CELL6'])';
end

