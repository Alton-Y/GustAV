%% Grab all filenames
clear
clc

% directory of flight
basefolder = 'Flight';

% subfolders
pixhawkpath = sprintf('%s/Pixhawk',basefolder);
weatherpath = sprintf('%s/WeatherStation',basefolder);

% find all files in subdirectories with specific extensions
pixhawkfiles = fcnFILELIST(pixhawkpath,'.mat');
weatherfiles = fcnFILELIST(weatherpath,'.CSV');

%% Load all files and format
% SETUP
INFO.timezone = -4;

% pixhawk output
[INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles(2));
[ INFO ] = fcnGETINFO( INFO, FMT );
%
%ground station files
GNDSTN = fcnGNDSTNLOAD(INFO,weatherpath,weatherfiles);

%% Plotting Package
fcnPLOTPACKAGE(INFO,FMT,GNDSTN);