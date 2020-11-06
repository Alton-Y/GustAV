
%% Grab all filenames
clear
clc

% directory of flight
basefolder = 'Flight';

% subfolders
pixhawkpath = sprintf('%s/Pixhawk',basefolder);
weatherpath ='C:\Users\Bill\Desktop\dataflash\WeatherStation';
aventechpath = sprintf('%s/Aventech',basefolder);
tlogpath = sprintf('%s/Tlogs',basefolder);
temploggerpath = 'C:\Users\Bill\Desktop\dataflash\TempLogger';

% find all files in subdirectories with specific extensions
pixhawkfiles = fcnFILELIST(pixhawkpath,'.mat');
weatherfiles = fcnFILELIST(weatherpath,'.CSV');
aventechfiles = fcnFILELIST(aventechpath,'_adp.out');
tlogfiles = fcnFILELIST(tlogpath,'.mat');
templogfiles=  fcnFILELIST(temploggerpath,'.CSV');

%% Load all files and format
% SETUP
INFO.timezone = 0;

% link to dataflash:
% if you have the dataflash .mat path:

% [INFO, FMT] = fcnFMTLOAD(INFO,'C:\Users\Bill\Documents\Mission Planner\logs\FIXED_WING\1\squeezetest.BIN-68525.mat');
[INFO, FMT] = fcnFMTLOAD(INFO,'C:\Users\Bill\Desktop\dataflash\00000002.BIN-20400445.mat');
% [INFO, FMT] = fcnFMTLOAD(INFO,'F:\APM\LOGS\00000001.BIN-41536.mat');
%or if you want to load from the Flight folder:
% [INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles(10));


[ INFO ] = fcnGETINFO( INFO, FMT );
%
%ground station files

 GND = fcnGNDLOAD(INFO,weatherpath,weatherfiles(1),3);
% GND = 'nan';

TEMPLOG = fcnTEMPLOAD(INFO,temploggerpath,templogfiles(1));
% TEMPLOG = 'nan';

% Aventch Files
AVT = fcnAVTLOAD(INFO,aventechpath,aventechfiles(1));

% TLog Files
% if you have the tlog .mat path:
TLOG = 'nan';
% TLOG = fcnTLOGLOAD(INFO, 'C:\Users\Bill\Desktop\dataflash\alttest\p6.tlog.mat');
% TLOG = fcnTLOGLOAD(INFO, 'C:\Users\Bill\Desktop\dataflash\2019-10-06 11-06-54.tlog.mat');

% or if you want to load from the Flight folder:
% TLOG = fcnTLOGLOAD(INFO, tlogpath, tlogfiles(1));
%% Plotting Package
% close all
fcnPLOTPACKAGE(INFO,FMT,GND,AVT,TLOG,TEMPLOG);

%% Sync FMT, GND, AVT to common timeseries
% try
% Set timeseries frequency
syncFreq = 30; 
% syncDatenum holds the datenums of each synced datapoint 

% syncDatenum =min(INFO.flight.startTimeLOCAL):1/syncFreq/86400:(10000 / 86400) + INFO.pixhawkstart;
% syncDatenum = (5000 / 86400) + INFO.pixhawkstart:1/syncFreq/86400:max(INFO.flight.endTimeLOCAL);
% syncDatenum = (5000 / 86400) + INFO.pixhawkstart:1/syncFreq/86400:(18000 / 86400) + INFO.pixhawkstart;
syncDatenum = min(INFO.flight.startTimeLOCAL):1/syncFreq/86400:max(INFO.flight.endTimeLOCAL);
% convert syncDatenum to TimeS for plotting
% syncTimeS = (syncDatenum-INFO.pixhawkstart).*86400;
% Sync FMT, GND, AVT to common syncDatenum
[ SYNCFMT ] = fcnSYNC( FMT, syncDatenum, 'linear', 1 );
[ SYNCGND ] = fcnSYNC( GND, syncDatenum, 'linear', 2 );
[ SYNCAVT ] = fcnSYNC( AVT, syncDatenum, 'linear', 3 );

% catch
%     warning('Error syncing data')
% end
