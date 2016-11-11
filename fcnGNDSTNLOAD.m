function GNDSTN = fcnGNDSTNLOAD(weatherpath,weatherfiles)
%This funciton loads the CSV data from the weather station into the
%corresponding .mat files.
listing = weatherfiles;


for num = 1:length(listing)
    
    
    filename = listing{num}
    delimiter = ',';
    formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
    
    
    
    fileID = fopen(strcat('./',weatherpath,'/',filename),'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
    fclose(fileID);
    raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
    for col=1:length(dataArray)-1
        raw(1:length(dataArray{col}),col) = dataArray{col};
    end
    numericData = NaN(size(dataArray{1},1),size(dataArray,2));
    for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        % Converts text in the input cell array to numbers. Replaced non-numeric
        % text with NaN.
        rawData = dataArray{col};
        for row=1:size(rawData, 1);
            % Create a regular expression to detect and remove non-numeric prefixes and
            % suffixes.
            regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
            try
                result = regexp(rawData{row}, regexstr, 'names');
                numbers = result.numbers;
                
                % Detected commas in non-thousand locations.
                invalidThousandsSeparator = false;
                if any(numbers==',');
                    thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                    if isempty(regexp(numbers, thousandsRegExp, 'once'));
                        numbers = NaN;
                        invalidThousandsSeparator = true;
                    end
                end
                % Convert numeric text to numbers.
                if ~invalidThousandsSeparator;
                    numbers = textscan(strrep(numbers, ',', ''), '%f');
                    numericData(row, col) = numbers{1};
                    raw{row, col} = numbers{1};
                end
            catch me
            end
        end
    end
    R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
    raw(R) = {NaN}; % Replace non-numeric cells
    %
    Year = cell2mat(raw(:, 6));
    idx = Year ~= 0 & Year < 20;
    % Allocate imported array to column variable names
    
    Month = cell2mat(raw(idx, 4));
    Day = cell2mat(raw(idx, 5));
    Year = cell2mat(raw(idx, 6));
    Hour = cell2mat(raw(idx, 7));
    Minute = cell2mat(raw(idx, 8));
    Second = cell2mat(raw(idx, 9));
    Millisecond = cell2mat(raw(idx, 10));
    
    LattitudeDeg = cell2mat(raw(idx, 1));
    LongitudeDeg = cell2mat(raw(idx, 2));
    
    Altitude = cell2mat(raw(idx, 3));
    Humidity = cell2mat(raw(idx, 11));
    Temp = cell2mat(raw(idx, 12));
    Pressure = cell2mat(raw(idx, 13));
    WindSpeed = cell2mat(raw(idx, 14));
    WindDirection = cell2mat(raw(idx, 15));
    
    Time = datenum(Year+2000,Month,Day,Hour-4,Minute,Second+Millisecond./1000);
    
    if exist('GNDSTN') == 0
        GNDSTN.Time = Time;
        GNDSTN.Humidity = Humidity;
        GNDSTN.Temp = Temp;
        GNDSTN.Pressure = Pressure;
        GNDSTN.WindSpeed = WindSpeed;
        GNDSTN.WindDirection = WindDirection;
    else
        GNDSTN.Time = [GNDSTN.Time;Time;];
        GNDSTN.Humidity = [GNDSTN.Humidity;Humidity;];
        GNDSTN.Temp = [GNDSTN.Temp;Temp;];
        GNDSTN.Pressure = [GNDSTN.Pressure;Pressure;];
        GNDSTN.WindSpeed = [GNDSTN.WindSpeed;WindSpeed;];
        GNDSTN.WindDirection = [GNDSTN.WindDirection;WindDirection;];
    end
    
    
end
%%
%
% Clear temporary variables
clearvars -except GNDSTN
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