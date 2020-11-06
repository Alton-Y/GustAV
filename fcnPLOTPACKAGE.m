function [] = fcnPLOTPACKAGE(INFO,FMT,GND,AVT,TLOG,TEMPLOG)
addpath('./PlotPackage')
% 
% genfig=figure(1);
% generalinfo(INFO,FMT,GND,AVT,genfig);
% 
% windfig = figure(2);
% winddata(INFO,FMT,GND,AVT,windfig);
% 
% rollpitchcontrolfig = figure(3);
% RPcontrolexplore(INFO,FMT,GND,rollpitchcontrolfig);
% 
% channelfig = figure(4);
% channeldata(INFO,FMT,GND,channelfig);
% 
% ekffig = figure(5);
% ekfexplore(INFO,FMT,GND,ekffig);
% 
% tecsfig = figure(6);
% tecsexplore(INFO,FMT,GND,tecsfig);
% 
battfig = figure(7);
batterydata(INFO,FMT,GND,battfig);
% 
% posfig = figure(8);
% position(INFO,FMT,GND,AVT,posfig);
% % 
% motorfig = figure(9);
% motordata(INFO,FMT,motorfig);
% 
% telemfig = figure(10);
% rssidata(INFO,FMT,TLOG,telemfig);
% 
% hardwarefig = figure(11);
% hardware(INFO,FMT,TLOG,hardwarefig);
% 
% sysidfig = figure(12);
% sysidexplore(INFO,FMT,sysidfig);

% airspeedfig = figure(13);
% airspeedexplore(INFO,FMT,airspeedfig);

% altfig = figure(14);
% altitudeexplore(INFO,FMT,altfig);
% 
% logfig = figure(15);
% logging(INFO,FMT,TLOG,logfig);
% 
% fig = figure(16)
% batterydata2(INFO,FMT,GND,fig)
% % 
% temperaturefig = figure(17)
% temperaturedata(INFO,FMT,GND,TEMPLOG,temperaturefig);
% 
% fig = figure(18)
% chargingdata(INFO,FMT,GND,TEMPLOG,fig)
