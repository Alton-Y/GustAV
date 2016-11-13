function [] = fcnPLOTPACKAGE(INFO,FMT,GNDSTN)
addpath('./PlotPackage')

genfig=figure(1);
generalinfo(INFO,FMT,GNDSTN,genfig);

windfig = figure(2);
winddata(INFO,FMT,GNDSTN,windfig);

tunefig = figure(3);
tuningdata(INFO,FMT,GNDSTN,tunefig);

ekffig = figure(4);
ekfexplore(INFO,FMT,GNDSTN,ekffig);