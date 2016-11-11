function GNDSTN = fcnGNDSTNLOAD(INFO,weatherpath,weatherfiles)
%This funciton loads the CSV data from the weather station into the
%corresponding .mat files.
listing = weatherfiles;

rawCSV = [];
fprintf('Loading %i Weather CSV Files.\n',length(weatherfiles));
for num = 1:length(listing)
    
    
    filename = strcat('./',weatherpath,'/',listing{num});

    
    try
        M = csvread(filename,1,0);
        fprintf('%s\n',listing{num});
    catch
        M = [];
        warning(sprintf('Unable to load %s',listing{num}));
    end
    
    if isempty(rawCSV) == 1;
        rawCSV = M;
    else
        rawCSV = [rawCSV;M];
    end
end
    
    

    Year = rawCSV(:, 6);
    idx = Year ~= 0 & Year < 20;
    % Allocate imported array to column variable names
    
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
    
    Time = datenum(Year+2000,Month,Day,Hour+INFO.timezone,Minute,Second+Millisecond./1000);
    
    GNDSTN.TimeLOCAL = Time;
    GNDSTN.TimeS = (Time - INFO.pixhawkstart).*24.*3600;
    GNDSTN.Humidity = Humidity;
    GNDSTN.TempC = Temp;
    GNDSTN.TempF = convtemp(Temp, 'C','F') ;
    GNDSTN.Pressure = Pressure;
    GNDSTN.WindSpeed = WindSpeed;
    GNDSTN.WindDirection = WindDirection;
    
    

%%
%
% Clear temporary variables
% clearvars -except GNDSTN
% clearvars filename delimiter formatSpec fileID dataArray ...
%     ans raw col numericData rawData row regexstr result ...
%     numbers invalidThousandsSeparator thousandsRegExp me R;
% Time = GNDSTN.Time;
% Humidity = GNDSTN.Humidity;
% Temp = GNDSTN.Temp;
% Pressure = GNDSTN.Pressure;
% WindSpeed = GNDSTN.WindSpeed;
% WindDirection = GNDSTN.WindDirection;
% clear GNDSTN;





end