%% Grab all filenames
% clear
clc

% directory of flight
basefolder = 'Flight';

% subfolders
pixhawkpath = sprintf('%s/Pixhawk',basefolder);
weatherpath = sprintf('%s/WeatherStation',basefolder);
aventechpath = sprintf('%s/Aventech',basefolder);

% find all files in subdirectories with specific extensions
pixhawkfiles = fcnFILELIST(pixhawkpath,'.mat');
weatherfiles = fcnFILELIST(weatherpath,'.CSV');
aventechfiles = fcnFILELIST(aventechpath,'_adp.out');
%% Load all files and format
% SETUP
INFO.timezone = 0;

% pixhawk output
[INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles(6));
[ INFO ] = fcnGETINFO( INFO, FMT );
%
%ground station files
GND = fcnGNDLOAD(INFO,weatherpath,weatherfiles(1),3);

% Aventch Files
AVT = fcnAVTLOAD(INFO,aventechpath,aventechfiles(3));

%% Plotting Package
% close all
fcnPLOTPACKAGE(INFO,FMT,GND,AVT);

%% Sync FMT, GND, AVT to common timeseries
% Set timeseries frequency
syncFreq = 30; 
% syncDatenum holds the datenums of each synced datapoint 
syncDatenum = min(INFO.flight.startTimeLOCAL):1/syncFreq/86400:max(INFO.flight.endTimeLOCAL);
% convert syncDatenum to TimeS for plotting
syncTimeS = (syncDatenum-INFO.pixhawkstart).*86400;
% Sync FMT, GND, AVT to common syncDatenum
[ SYNCFMT ] = fcnSYNC( FMT, syncDatenum, 'linear', 1 );
[ SYNCGND ] = fcnSYNC( GND, syncDatenum, 'linear', 2 );
[ SYNCAVT ] = fcnSYNC( AVT, syncDatenum, 'linear', 3 );

