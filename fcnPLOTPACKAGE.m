function [] = fcnPLOTPACKAGE(INFO,FMT,GNDSTN,AVT)
addpath('./PlotPackage')

genfig=figure(1);
generalinfo(INFO,FMT,GNDSTN,genfig);
% 
windfig = figure(2);
winddata(INFO,FMT,GNDSTN,AVT,windfig);
% 
tunefig = figure(3);
tuningdata(INFO,FMT,GNDSTN,tunefig);
% % 
channelfig = figure(4);
channeldata(INFO,FMT,GNDSTN,channelfig);

ekffig = figure(5);
ekfexplore(INFO,FMT,GNDSTN,ekffig);
% 
tecsfig = figure(6);
tecsexplore(INFO,FMT,GNDSTN,tecsfig);
% 
battfig = figure(7);
batterydata(INFO,FMT,GNDSTN,battfig);
% 
