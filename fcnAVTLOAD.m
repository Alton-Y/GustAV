function AVT = fcnAVTLOAD(INFO,aventechpath,aventechfiles)
fprintf('\n')
try
    % year = 2017;
    month = str2double(aventechfiles{1}(1:2));
    day = str2double(aventechfiles{1}(3:4));
    
    dateLOCAL = datenum(2017,month,day);
catch
    fprintf('Aventech Date Error.\n')
end

%%
leapSecs = 17;
ADPdataFreq = 50;
OUTdataFreq = 1;
IMUdataFreq = 100;


%%

try % IMPORT ADP FILE
    ADPfilename = strcat(aventechpath,'/',aventechfiles{1});
    
    startRow = 3;
    formatSpec = '%10f%8f%8f%8f%7f%6f%6f%f%[^\n\r]';
    fileID = fopen(ADPfilename,'r');
    textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false);
    fclose(fileID);
    TimeH = dataArray{:, 1};
    
    idx = TimeH > 0;
    % TimeHStart = TimeH(find(idx,1));
    % TimeNew = ((1:length(TimeH))'-find(idx,1))./50./60./60;
    
    AVT.ADP.TempFast = dataArray{:,2}(idx);
    AVT.ADP.Temp = dataArray{:,3}(idx);
    AVT.ADP.RH = dataArray{:,4}(idx);
    AVT.ADP.P_STATIC = dataArray{:,5}(idx);
    AVT.ADP.P_ALPHA = dataArray{:,6}(idx);
    AVT.ADP.P_BETA = dataArray{:,7}(idx);
    AVT.ADP.P_PS = dataArray{:,8}(idx);
    % clearvars filename startRow formatSpec fileID dataArray ans
    
    [ ADPTimeAddH ] = fcnAVTTIME( TimeH(idx), ADPdataFreq );
    
    %leap secs
    ADPTimeCorrectedH = TimeH(idx) + ADPTimeAddH + leapSecs/3600;
    
    
    AVT.ADP.TimeH = ADPTimeCorrectedH;
    AVT.ADP.TimeLOCAL = dateLOCAL + ADPTimeCorrectedH./24;
    AVT.ADP.TimeS = (AVT.ADP.TimeLOCAL-INFO.pixhawkstart).*86400;
    
    
    fprintf('Aventech ADP %s Loaded.\n',aventechfiles{1})
    
catch
    fprintf('Aventech ADP %s ERROR.\n',aventechfiles{1})
end



try % IMPORT AIMMS FILE
    AIMMSfilename = strrep(strcat(aventechpath,'/',aventechfiles{1}),'_adp','_aimms');
    startRow = 4;
    delimiter = ' ';
    formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%[^\n\r]';
    fileID = fopen(AIMMSfilename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    
    AVT.AIMMS.TimeH = dataArray{:, 1};
    
    AVT.AIMMS.TimeLOCAL = dateLOCAL + AVT.AIMMS.TimeH./24  + leapSecs/86400;
    AVT.AIMMS.TimeS = (AVT.AIMMS.TimeLOCAL-INFO.pixhawkstart).*86400;
    
    AVT.AIMMS.Temp = dataArray{:, 2};
    AVT.AIMMS.RH = dataArray{:, 3};
    AVT.AIMMS.P_stat = dataArray{:, 4};
    AVT.AIMMS.Uw = dataArray{:, 5};
    AVT.AIMMS.Vw = dataArray{:, 6};
    AVT.AIMMS.Lat = dataArray{:, 7};
    AVT.AIMMS.Long = dataArray{:, 8};
    AVT.AIMMS.Z = dataArray{:, 9};
    AVT.AIMMS.Ui = dataArray{:, 10};
    AVT.AIMMS.Vi = dataArray{:, 11};
    AVT.AIMMS.Wi = dataArray{:, 12};
    AVT.AIMMS.Roll = dataArray{:, 13};
    AVT.AIMMS.Pitch = dataArray{:, 14};
    AVT.AIMMS.Heading = dataArray{:, 15};
    AVT.AIMMS.TAS = dataArray{:, 16};
    AVT.AIMMS.Wi1 = dataArray{:, 17};
    AVT.AIMMS.AoS = dataArray{:, 18};
    AVT.AIMMS.P_beta = dataArray{:, 19};
    AVT.AIMMS.P_alpha = dataArray{:, 20};
    AVT.AIMMS.C_p = dataArray{:, 21};
    
    fprintf('Aventech AIMMS %s Loaded.\n',AIMMSfilename)
catch
    fprintf('Aventech AIMMS %s ERROR.\n',AIMMSfilename)
end



for n = 1:2 % LOAD GPSSAT FILES (GPSSAT1 & GPSSAT2)
    if n == 1
        GPSSATfilename = strrep(strcat(aventechpath,'/',aventechfiles{1}),'_adp','_gpssat1');
        structName = 'GPSSAT1';
    else
        GPSSATfilename = strrep(strcat(aventechpath,'/',aventechfiles{1}),'_adp','_gpssat2');
        structName = 'GPSSAT2';
    end
    
    try % IMPORT AIMMS FILE
        GPSSAT = [];
        
        delimiter = ' ';
        startRow = 2;
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
        fileID = fopen(GPSSATfilename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
        fclose(fileID);
        
        GPSSAT.Cycle = dataArray{:, 1};
        GPSSAT.TimeWk = dataArray{:, 2};
        
        GPSSAT.TimeLOCAL = dateLOCAL + rem(GPSSAT.TimeWk,86400)./86400 + leapSecs/86400;
        GPSSAT.TimeS = (GPSSAT.TimeLOCAL-INFO.pixhawkstart).*86400;
        
        GPSSAT.SatOK = dataArray{:, 3};
        GPSSAT.SatNotOk = dataArray{:, 4};
        GPSSAT.SatRef = dataArray{:, 5};
        GPSSAT.SatStatus = dataArray{:, 6};
        GPSSAT.NavMode = dataArray{:, 7};
        GPSSAT.SatCount = dataArray{:, 8};
        %     VarName32 = dataArray{:, 32};
        
        AVT.(structName) = GPSSAT;
        
        fprintf('Aventech %s %s Loaded.\n',structName, GPSSATfilename)
    catch
        fprintf('Aventech %s %s ERROR.\n',structName, GPSSATfilename)
    end
end




try % IMPORT IMUINT FILE
    IMUINTfilename = strrep(strcat(aventechpath,'/',aventechfiles{1}),'_adp','_imuint');
    delimiter = ' ';
    formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
    fileID = fopen(IMUINTfilename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
    fclose(fileID);
    
    % This can check if the integration cycle matches the column index
    if sum((dataArray{:, 1} == (1:length(dataArray{:, 1}))')~=1)~= 0
        warning('integration cycle does not match the column index');
    end
    
    cycleIndex = AVT.GPSSAT1.Cycle ~= 0;
    cycle = AVT.GPSSAT1.Cycle(cycleIndex);
    timelocal = AVT.GPSSAT1.TimeLOCAL(cycleIndex) - leapSecs/86400;
    
    % Back track to cycle index = 0
%     cycle0 = dateLOCAL + rem(timeWk(1),86400)./86400 - cycle(1)/86400*(1/IMUdataFreq);
    
    % preallocation
    AVT.IMUINT.TimeLOCAL = nan(length(dataArray{:, 1}),1);
    
    AVT.IMUINT.TimeLOCAL(cycle) = timelocal;
    
    for n = 2:length(AVT.IMUINT.TimeLOCAL)
        if isnan(AVT.IMUINT.TimeLOCAL(n)) == 1
            AVT.IMUINT.TimeLOCAL(n) = AVT.IMUINT.TimeLOCAL(n-1)+1/IMUdataFreq/86400;
        end
    end
    
    AVT.IMUINT.Cycle 	 = dataArray{:, 1};
    
%     AVT.IMUINT.TimeLOCAL = cycle0 + AVT.IMUINT.Cycle.*(1/IMUdataFreq)./86400;
    AVT.IMUINT.TimeS = (AVT.IMUINT.TimeLOCAL-INFO.pixhawkstart).*86400;
    
    AVT.IMUINT.Roll 	 = dataArray{:, 2};
    AVT.IMUINT.Pitch 	 = dataArray{:, 3};
    AVT.IMUINT.Yaw 		 = dataArray{:, 4};
    AVT.IMUINT.RollRate  = dataArray{:, 5};
    AVT.IMUINT.PitchRate = dataArray{:, 6};
    AVT.IMUINT.YawRate 	 = dataArray{:, 7};
    AVT.IMUINT.VN 		 = dataArray{:, 8};
    AVT.IMUINT.VE 		 = dataArray{:, 9};
    AVT.IMUINT.VD 		 = dataArray{:, 10};
    AVT.IMUINT.AccN 	 = dataArray{:, 11};
    AVT.IMUINT.AccE 	 = dataArray{:, 12};
    AVT.IMUINT.AccD 	 = dataArray{:, 13};
    AVT.IMUINT.BiasX 	 = dataArray{:, 14};
    AVT.IMUINT.BiasY 	 = dataArray{:, 15};
    AVT.IMUINT.BiasZ 	 = dataArray{:, 16};
    AVT.IMUINT.GyrX 	 = dataArray{:, 17};
    AVT.IMUINT.GyrY 	 = dataArray{:, 18};
    AVT.IMUINT.GyrZ 	 = dataArray{:, 19};
    AVT.IMUINT.AccX 	 = dataArray{:, 20};
    AVT.IMUINT.AccY 	 = dataArray{:, 21};
    AVT.IMUINT.AccZ 	 = dataArray{:, 22};
    
    fprintf('Aventech IMUINT %s Loaded.\n',IMUINTfilename)
catch
    fprintf('Aventech IMUINT %s ERROR.\n',IMUINTfilename)
end







OUTfilename = strrep(strcat(aventechpath,'/',aventechfiles{1}),'_adp','');
formatSpec = '%11f%7f%6f%7f%7f%7f%10f%11f%6f%8f%8f%8f%7f%7f%7f%6f%7f%7f%8f%8f%4f%C%[^\n\r]';
fileID = fopen(OUTfilename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);

[ OUTTimeAddH ] = fcnAVTTIME( dataArray{:,1}, OUTdataFreq );

OUTTimeCorrectedH = dataArray{:,1} + OUTTimeAddH + leapSecs/3600;
AVT.OUT.TimeLOCAL = dateLOCAL + OUTTimeCorrectedH./24;
AVT.OUT.TimeS = (AVT.OUT.TimeLOCAL-INFO.pixhawkstart).*86400;

% AVT.OUT.Temp = dataArray{:, 2};
% AVT.OUT.RH = dataArray{:, 3};
% AVT.OUT.Pressure = dataArray{:, 4};
% VarName5 = dataArray{:, 5};
% VarName6 = dataArray{:, 6};
AVT.OUT.Lat = dataArray{:, 7};
AVT.OUT.Lon = dataArray{:, 8};
AVT.OUT.Alt = dataArray{:, 9};
% VarName10 = dataArray{:, 10};
% VarName11 = dataArray{:, 11};
% VarName12 = dataArray{:, 12};
% VarName13 = dataArray{:, 13};
% VarName14 = dataArray{:, 14};
% VarName15 = dataArray{:, 15};
AVT.OUT.ARSP = dataArray{:, 16};
% VarName17 = dataArray{:, 17};
% AVT.OUT.A = dataArray{:, 18};
% AVT.OUT.B = dataArray{:, 19};
% AVT.OUT.C = dataArray{:, 20};
% VarName21 = dataArray{:, 21};
% VarName22 = dataArray{:, 22};























end













