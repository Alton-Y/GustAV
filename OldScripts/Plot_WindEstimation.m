% clc
% clear
%
% INFO.Date = '2016-06-11';
% INFO.Flight = 3;
% INFO.Aircraft = 'Bix 3';
%
%
% FMT = FMT_Load(sprintf('logs/%s_Flight%i.mat',INFO.Date,INFO.Flight));
% INFO = FMT_GetInfo(INFO,FMT);
%
%
% PLOT.Segment = 0;
% PLOT.isArmed = 1;
% PLOT.isFlying = 1;


function [] = Plot_WindEstimation(INFO,PLOT,FMT)

Plot_Off;
[ PLOT.MSG ] = MSG_Filter( INFO, {'GPS'} );
PLOT.Title = 'WIND DIRECTION AND VELOCITY ESTIMATION';


% INFO = FMT_GetInfo(INFO,FMT);

[ VWN, TimeNKF2 ] = Data_Trim(FMT,INFO,'NKF2','VWN',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ VWE, ~ ] = Data_Trim(FMT,INFO,'NKF2','VWE',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);


WIND_SPD = (VWE.^2+VWN.^2).^0.5;

% Wind directino (From)
WIND_DIR = rem(90-atan2d(VWN,VWE)+180,360);


% figure
set(gcf,'GraphicsSmoothing','on')
% orient landscape
set(gcf,'Color',[1 1 1]);

ax1 = subplot(3,1,1);
Plot_Format(gca);
plot(TimeNKF2,[VWN,VWE]);
ylabel('WIND COMPONENTS [m/s]');
xlabel('TIME [s]');
legend('NORTH','EAST');

ax2 = subplot(3,1,2);
Plot_Format(gca);
plot(TimeNKF2, WIND_SPD);
ylabel('WIND VELOCITY [m/s]');
xlabel('TIME [s]');

ax3 = subplot(3,1,3);
Plot_Format(gca);
p3 = plot(TimeNKF2, WIND_DIR);
ylabel('WIND DIRECTION (FROM) [deg]');
xlabel('TIME [s]');



linkaxes([ax1,ax2,ax3],'x')


Plot_Create(INFO,PLOT,'WindEstimation');


close all
Plot_On


end




