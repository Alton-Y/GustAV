function GNDSTN = fcnGNDSTNLOAD(INFO,weatherpath,weatherfiles,version)
%This funciton loads the CSV data from the weather station into the
%corresponding .mat files.
listing = weatherfiles;

rawCSV = [];
fprintf('Loading %i Weather CSV Files.\n',length(weatherfiles));
for num = 1:length(listing)
    
    filename = strcat(weatherpath,'/',listing{num});
    
    try
        M = csvread(filename,1,0);
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


%% Filtering Data with No GPS Lock
Year = rawCSV(:,6);
idx = Year ~= 0 & Year < 20;
% Allocate imported array to column variable names


if version == 1
    Month = rawCSV(idx, 4);
    Day = rawCSV(idx, 5);
    Year = rawCSV(idx, 6);
    Hour = rawCSV(idx, 7);
    Minute = rawCSV(idx, 8);
    Second = rawCSV(idx, 9);
    Millisecond = rawCSV(idx, 10);
    LattitudeDeg = rawCSV(idx, 1);
    LongitudeDeg = rawCSV(idx, 2);
    Altitude = rawCSV(idx, 3);
    Humidity = rawCSV(idx, 11);
    Temp = rawCSV(idx, 12);
    Pressure = rawCSV(idx, 13);
    WindSpeed = rawCSV(idx, 14);
    WindDirection = rawCSV(idx, 15);
    TimeLOCAL = datenum(Year+2000,Month,Day,Hour+INFO.timezone,Minute,Second+Millisecond./1000);
    
    
elseif version == 2
    LattitudeDeg = rawCSV(idx, 1);
    LongitudeDeg = rawCSV(idx, 2);
    Altitude = rawCSV(idx, 3);
    Month = rawCSV(idx, 4);
    Day = rawCSV(idx, 5);
    Year = rawCSV(idx, 6);
    Hour = rawCSV(idx, 7);
    Minute = rawCSV(idx, 8);
    Second = rawCSV(idx, 9);
    Millisecond = rawCSV(idx, 10);
    Humidity = rawCSV(idx, 11);
    Temp = rawCSV(idx, 12);
    Pressure = rawCSV(idx, 13);
    WindSpeed = rawCSV(idx, 14);
    WindDirection = rawCSV(idx, 15);
    TimeMS = rawCSV(idx, 16);
    LogNo = LogNo(idx, :);
    
    
    % NaN Handling
    Pressure = Pressure./10;
    WindSpeed(WindSpeed < 0) = nan;
    Pressure(Pressure < 100) = nan;
    WindDirection(WindDirection == 0) = nan;
    %% Find TimeLOCAL with TimeMS
    for num = 1:length(listing)
       idx2 = (LogNo==num);
       I = find(idx2==1,1);
       FirstTimeLOCAL = datenum(Year(I)+2000,Month(I),Day(I),Hour(I)+INFO.timezone,Minute(I),Second(I)+Millisecond(I)./1000);
       Offset = FirstTimeLOCAL - TimeMS(I)./1000./86400;
       TimeLOCAL(idx2) = TimeMS(idx2)./1000./86400 + Offset;
    end
    
    
    

end








%%





GNDSTN.TimeLOCAL = TimeLOCAL;
GNDSTN.TimeS = (TimeLOCAL - INFO.pixhawkstart).*24.*3600;
GNDSTN.Humidity = Humidity;
GNDSTN.TempC = Temp;
GNDSTN.TempF = convtemp(Temp, 'C','F') ;
GNDSTN.Pressure = Pressure;
GNDSTN.WindSpeed = WindSpeed;
GNDSTN.WindDirection = WindDirection;
try
    GNDSTN.TimeMS = TimeMS;
end


end