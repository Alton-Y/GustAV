% INFO.Date = '2016-06-04';
% INFO.Flight = 1;
% INFO.Aircraft = 'Bix 3';

% FMT = FMT_Load('2016-06-13_BatTest2.mat');
% FMT = FMT_Load(sprintf('logs/%s_Flight%i.mat',INFO.Date,INFO.Flight));
% INFO = FMT_GetInfo(INFO,FMT);
% INFO.GNDTEST = 0;
%
% PLOT.Segment = 0;
% PLOT.isArmed = 1;
% PLOT.isFlying = 1;



function [] = Plot_BatteryMonitor(INFO,PLOT,FMT,BATnum)




Plot_Off;
[ PLOT.MSG ] = MSG_Filter( INFO, {'BATT'} );


% INFO = FMT_GetInfo(INFO,FMT);




try
    if BATnum == 1
        PLOT.Title = 'BATTERY #1 VOLTAGE AND CURRENT';
        [ Volt, TimeCURR ] = Data_Trim(FMT,INFO,'CURR','Volt',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
        [ Curr, ~ ] = Data_Trim(FMT,INFO,'CURR','Curr',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
        [ CurrTot, ~ ] = Data_Trim(FMT,INFO,'CURR','CurrTot',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
        [ RCIN3, TimeRCIN ] = Data_Trim(FMT,INFO,'RCIN','C3',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
        [ RCOU3, TimeRCOU ] = Data_Trim(FMT,INFO,'RCOU','C3',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
        saveName = 'BatteryMonitor1';
    elseif BATnum == 2
        PLOT.Title = 'BATTERY #2 VOLTAGE AND CURRENT';
        [ Volt, TimeCURR ] = Data_Trim(FMT,INFO,'CUR2','Volt',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
        [ Curr, ~ ] = Data_Trim(FMT,INFO,'CUR2','Curr',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
        [ CurrTot, ~ ] = Data_Trim(FMT,INFO,'CUR2','CurrTot',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
        [ RCIN3, TimeRCIN ] = Data_Trim(FMT,INFO,'RCIN','C3',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
        saveName = 'BatteryMonitor2';
%         Volt = Volt.*100;
%         Curr = Curr.*100;
        
    end
catch
    PLOT.Title = 'BATTERY VOLTAGE AND CURRENT';
    [ Volt, TimeCURR ] = Data_Trim(FMT,INFO,'CURR','Volt',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
    [ Curr, ~ ] = Data_Trim(FMT,INFO,'CURR','Curr',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
    [ CurrTot, ~ ] = Data_Trim(FMT,INFO,'CURR','CurrTot',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
    % [ Throttle, ~ ] = Data_Trim(FMT,INFO,'CURR','Throttle',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
    [ RCIN3, TimeRCIN ] = Data_Trim(FMT,INFO,'RCIN','C3',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
    %[ RCOU3, TimeRCOU ] = Data_Trim(FMT,INFO,'RCOU','Ch3',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
    saveName = 'BatteryMonitor';
end




% plot(TimeCURR,Watt)


%%



% figure
% set(gcf,'GraphicsSmoothing','on')
clf

set(gcf, 'Position', [200 200 1100 650])
set(gcf,'Color',[1 1 1]);

ax1 = subplot(3,1,1);
Plot_Format(gca);

hold on
yyaxis left
plot(TimeCURR,[Curr],'--');
ylabel('CURRENT [A]');
yyaxis right
plot(TimeCURR,[Volt]);
ylabel('VOLTAGE [V]');
hold off

xlabel('TIME [s]');
legend('CURRENT','VOLTAGE','location','southwest');


ax2 = subplot(3,1,2);
Plot_Format(gca);
hold on
plot(TimeRCIN, RCIN3, 'k--');

try
plot(TimeRCOU, RCOU3, 'k-');
end

legend('RC IN','RC OUT','location','southwest');
ylim([1100 1910]);
ylabel('PWM RANGE');
xlabel('TIME [s]');
set(gca,'YTick',[1100:200:1900]);

yyaxis right
ylim([0 100]);
ylabel('THROTTLE [%]');
set(gca,'YColor',[0 0 0]);
set(gca,'YTick',[0:25:100]);

ax3 = subplot(3,1,3);
Plot_Format(gca);
plot(TimeCURR, CurrTot);
ylabel('DISCHARGE CAPACITY [mAh]');
xlabel('TIME [s]');
capacityLim = ylim;
ylim([0 capacityLim(2)]);

linkaxes([ax1,ax2,ax3],'x')

Plot_Create(INFO,PLOT,saveName);


close all
Plot_On;

end

