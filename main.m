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
[INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles(3));
[ INFO ] = fcnGETINFO( INFO, FMT );
%
%ground station files
GNDSTN = fcnGNDSTNLOAD(INFO,weatherpath,weatherfiles(16),3);

% Aventch Files
AVT = fcnAVTLOAD(INFO,aventechpath,aventechfiles(1));

%% Plotting Package
fcnPLOTPACKAGE(INFO,FMT,GNDSTN,AVT);