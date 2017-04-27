function AVT = fcnAVTLOAD(INFO,aventechpath,aventechfile);

year = 2017;
month = 04;
day = 23;

dateLOCAL = datenum(2017,04,23);

%%
leapSecs = 17;
dataFreq = 50;


%%


filename = strcat(aventechpath,'/',aventechfile{1});


% Initialize variables.
% filename = 'C:\Users\GustAV\Documents\MATLAB\GustAV\Flight\Aventech\04231735_adp.out';
startRow = 3;
formatSpec = '%10f%8f%8f%8f%7f%6f%6f%f%[^\n\r]';
fileID = fopen(filename,'r');
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false);
fclose(fileID);
TimeH = dataArray{:, 1};

idx = TimeH > 0;
% TimeHStart = TimeH(find(idx,1));
TimeNew = ((1:length(TimeH))'-find(idx,1))./50./60./60;



AVT.ADP.TempFast = dataArray{:,2}(idx);
AVT.ADP.Temp = dataArray{:,3}(idx);
AVT.ADP.RH = dataArray{:,4}(idx);
AVT.ADP.P_STATIC = dataArray{:,5}(idx);
AVT.ADP.P_ALPHA = dataArray{:,6}(idx);
AVT.ADP.P_BETA = dataArray{:,7}(idx);
AVT.ADP.P_PS = dataArray{:,8}(idx);
% clearvars filename startRow formatSpec fileID dataArray ans;


[~,~,C] = unique(TimeH(idx));
[a,~]=hist(C,unique(C));
a = a';
TimeAddH = [];

for n = 1:length(a)
    TimeAddH = [TimeAddH;((0:a(n)-1)')./dataFreq./3600];
end


%                                        leap secs
TimeCorrectedH = TimeH(idx) + TimeAddH + leapSecs/3600;


AVT.ADP.TimeH = TimeCorrectedH;
AVT.ADP.TimeLOCAL = dateLOCAL + TimeCorrectedH./24;
AVT.ADP.TimeS = (AVT.ADP.TimeLOCAL-INFO.pixhawkstart).*86400;

% plot(TimeH(idx)-TimeHStart,'.-')
% hold on
% plot(TimeNew)
% plot(TimeCorrectedH)
% hold off








end













