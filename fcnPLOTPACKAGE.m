function [] = fcnPLOTPACKAGE(INFO,FMT,GND,AVT)
addpath('./PlotPackage')

genfig=figure(1);
generalinfo(INFO,FMT,GND,AVT,genfig);
% % 
% windfig = figure(2);
% winddata(INFO,FMT,GND,AVT,windfig);
% % 
% tunefig = figure(3);
% tuningdata(INFO,FMT,GND,tunefig);
% % % 
channelfig = figure(4);
channeldata(INFO,FMT,GND,channelfig);
% 
% ekffig = figure(5);
% ekfexplore(INFO,FMT,GND,ekffig);
% 
% tecsfig = figure(6);
% tecsexplore(INFO,FMT,GND,tecsfig);
% 
% battfig = figure(7);
% batterydata(INFO,FMT,GND,battfig);
% 
% posfig = figure(8);
% position(INFO,FMT,GND,AVT,posfig);

motorfig = figure(9);
motordata(INFO,FMT,motorfig);
