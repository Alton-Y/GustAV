filename = 'C:\Users\GustAV\Google Drive\Ryerson UAV\Flights\2016-11-05\Weather Station\LOG16.CSV';
delimiter = ',';
formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
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


Year = cell2mat(raw(:, 6));
idx = Year <= 20 & Year >= 16;



LattitudeDeg = cell2mat(raw(idx, 1));
LongitudeDeg = cell2mat(raw(idx, 2));
Altitude = cell2mat(raw(idx, 3));
Month = cell2mat(raw(idx, 4));
Day = cell2mat(raw(idx, 5));
Year = cell2mat(raw(idx, 6));
Hour = cell2mat(raw(idx, 7));
Minute = cell2mat(raw(idx, 8));
Second = cell2mat(raw(idx, 9));
Millisecond = cell2mat(raw(idx, 10));
Humidity = cell2mat(raw(idx, 11));
Temp = cell2mat(raw(idx, 12));
Pressure = cell2mat(raw(idx, 13));
WindSpeed = cell2mat(raw(idx, 14));
WindDirection = cell2mat(raw(idx, 15));
Time = datenum(Year+2000,Month,Day,Hour,Minute,Second+Millisecond./1000);
clearvars filename delimiter formatSpec fileID dataArray ...
    ans raw col numericData rawData row regexstr result ...
    numbers invalidThousandsSeparator thousandsRegExp me R;