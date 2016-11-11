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

% pixhawk output
FMT = fcnFMTLOAD(pixhawkpath,pixhawkfiles);

%ground station files
GNDSTN = fcnGNDSTNLOAD(weatherpath,weatherfiles);

