% clc
% clear
% clf
% INFO.Date = '2016-05-28';
% INFO.Flight = 1;
% INFO.Aircraft = 'Bix 3';
% 
% 
% FMT = FMT_Load(sprintf('logs/%s_Flight%i.mat',INFO.Date,INFO.Flight));
% INFO = FMT_GetInfo(INFO,FMT);


function [] = Plot_AutotuneAnalysis(INFO,PLOT,FMT)
modeSegment = INFO.Modes.Segment(INFO.Modes.ModeNo==8); % check if autotune mode was active

if isempty(modeSegment)~=1

Plot_Off()

PLOT.Segment = modeSegment(1):modeSegment(end);
PLOT.isArmed = 1;
PLOT.isFlying = 1;
PLOT.Title = 'AUTOTUNE ANALYSIS';
INFO.GNDTEST = 0;

[ Demanded, TimeATRP ] = Data_Trim(FMT,INFO,'ATRP','Demanded',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ Type, ~ ] = Data_Trim(FMT,INFO,'ATRP','Type',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ State, ~ ] = Data_Trim(FMT,INFO,'ATRP','State',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ P, ~ ] = Data_Trim(FMT,INFO,'ATRP','P',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
[ Achieved, ~ ] = Data_Trim(FMT,INFO,'ATRP','Achieved',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);



idxRoll = (Type == 0);
TimeATRP_R = TimeATRP;
TimeATRP_R(~idxRoll) = NaN;
TimeATRP_P = TimeATRP;
TimeATRP_P(idxRoll) = NaN;


% figure
set(gcf,'GraphicsSmoothing','on')
% orient landscape
set(gcf,'Color',[1 1 1]);
 
ax1 = subplot(4,1,1);
Plot_Format(gca);
plot(TimeATRP_R,[Demanded,Achieved]);
ylabel('ROLL ANGLE [deg]');
xlabel('TIME [s]');
legend('DEMANDED','ACHIEVED','location','southwest');

ax2 = subplot(4,1,2);
Plot_Format(gca);
plot(TimeATRP_R, P,'.-');
ylabel('ROLL P VALUE');
xlabel('TIME [s]');

ax3 = subplot(4,1,3);
Plot_Format(gca);
plot(TimeATRP_P,[Demanded,Achieved]);
ylabel('PITCH ANGLE [deg]');
xlabel('TIME [s]');
legend('DEMANDED','ACHIEVED','location','southwest');

ax4 = subplot(4,1,4);
Plot_Format(gca);
plot(TimeATRP_P, P,'.-');
ylabel('PITCH P VALUE');
xlabel('TIME [s]');

linkaxes([ax1,ax2,ax3,ax4],'x')
linkaxes([ax1,ax3],'y')
linkaxes([ax2,ax4],'y')

Plot_Create(INFO,PLOT,'AutoTune');


close all
Plot_On()
end

