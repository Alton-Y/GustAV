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

if version ~= 3
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
    
    
    
else %if version is 3
    
    disp('weather log version 3')
    
    
    % GPS data
    % if age is not empty, the row contains valid GPS data
    idxGPS = rawCSV(:,12)~=0;
    age = rawCSV(idxGPS,12);
    Year = rawCSV(idxGPS,13);
    Month = rawCSV(idxGPS,14);
    Day = rawCSV(idxGPS,15);
    Hour = rawCSV(idxGPS,16);
    Minute = rawCSV(idxGPS,17);
    Second = rawCSV(idxGPS,18);
    HundredthSecond = rawCSV(idxGPS,19);
    GPSBoardTime = rawCSV(idxGPS,1);
    GPSSatTime = datenum(Year,Month,Day,Hour+INFO.timezone,Minute,Second+HundredthSecond./100+age./1000);
    
    dBoardTime = diff(GPSBoardTime)./1000;
    dSatTime = diff(GPSSatTime).*86400;
    
    if max(abs(dBoardTime-dSatTime)) > 1
        disp('GPS Time Sync Error');
    end
    
    SyncBoardTime = GPSBoardTime(1);
    SyncSatTime = GPSSatTime(1);
    
%     plot([GPStimeMS(1:end-1),GPStimeMS(1:end-1)],[dMS,dDatenum]);  
    
    


    % Filter Invalid Values
    % Negative or Zero Wind Speed
    idxW = rawCSV(:,3) > 0;
    % tempf = exactly 32.00
    idxT = rawCSV(:,5) ~= 32.0;
    % Negative or Zero Pressure
    idxP = rawCSV(:,6) > 0;
    % Combine filters
    idx = and(and(idxW,idxT),idxP);
    
    Humidity = rawCSV(idx,4);
    Temp = convtemp(rawCSV(idx,5), 'F','C');
    Pressure = rawCSV(idx,6);
    WindSpeed = rawCSV(idx,3);
    WindDirection = rawCSV(idx,2);
    TimeMS = rawCSV(idx,1);
    %TimeMS(79)
    TimeLOCAL = (TimeMS-SyncBoardTime)./1000./86400+SyncSatTime;
    

    GNDSTN.TimeLOCAL = TimeLOCAL;
    GNDSTN.TimeS = (TimeLOCAL - INFO.pixhawkstart).*24.*3600;
    GNDSTN.Humidity = Humidity;
    GNDSTN.TempC = Temp;
    GNDSTN.TempF = convtemp(Temp, 'C','F') ;
    GNDSTN.Pressure = Pressure;
    GNDSTN.WindSpeed = WindSpeed;
    GNDSTN.WindDirection = WindDirection;
end


%%








end