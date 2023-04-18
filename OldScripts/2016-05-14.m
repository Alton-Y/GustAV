clc
clear

FMT = FMT_Load('2016-05-14 14-24-57.log-1342852.mat');

INFO = INFO_Get(FMT);


clf
[ INFO ] = Plot_GPS_Mode( FMT, INFO );

box on


