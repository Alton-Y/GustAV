% % % FMT = FMT_Load('2016-06-18_BatTest1.mat');

% plot(FMT.CURR.TimeUS, FMT.CURR.Volt)
% plot(FMT.CURR.TimeUS, FMT.CURR.Curr)

% % % t = FMT.CURR.TimeUS./1e6;
% % % V = FMT.CURR.Volt;
% % % I = FMT.CURR.Curr;
% % % I2 = I.*2-0.37;
% % % tot = FMT.CURR.CurrTot;
% % % C = I2./8;
% % % 
% % % 
% % % % plot(TimeRCIN, RCIN3, 'k--');
% % % TimeRCIN = FMT.RCIN.TimeUS./1e6;
% % % RCIN3 = FMT.RCIN.C3;
% % % TimeRCOU = FMT.RCOU.TimeUS./1e6;
% % % RCOU3 = FMT.RCOU.C3;
% % % R = V./I;
% % % tot2 = cumtrapz(t./3600,I2.*1000);
% % % 
% % % figure
% % % RPM = [2200:50:7500];
% % % test_V = [-6.86005E-12.*RPM.^3+4.02615E-08.*RPM.^2+-0.0001442.*RPM+22.45020151];
% % % test_I = [1.33996E-10.*RPM.^3+-3.27452E-07.*RPM.^2+0.000798888.*RPM];
% % % scatter(V,I)
% % % hold on
% % % scatter3(test_V,test_I,RPM)
% % % hold off
% % % 
% % % 
% % % 
% % % figure
% % % subplot(3,1,1)
% % % plot(t,R)
% % % xlim([175 1110])
% % % 
% % % xlabel('Time');
% % % ylabel('R');
% % % subplot(3,1,2)
% % % plot(t,V)
% % % xlabel('Time');
% % % ylabel('Voltage [V]');
% % % xlim([175 1110])
% % % 
% % % subplot(3,1,3)
% % % plot(t,I2)
% % % xlabel('Time');
% % % ylabel('Current [A]');
% % % xlim([175 1110])


log1 = load('C:\Users\Alton Yeung\Google Drive\Ryerson UAV\Flights (1)\test\20160824_3S1000mAh\4.log-2000000.mat');
log2 = load('C:\Users\Alton Yeung\Google Drive\Ryerson UAV\Flights (1)\test\20160824_3S1000mAh\4.log-3475307.mat');
%
TimeCURR = [log1.CUR2(:,2);log2.CUR2(:,2)];
Volt = [log1.CUR2(:,3);log2.CUR2(:,3)];
Curr = [log1.CUR2(:,4);log2.CUR2(:,4)];
CurrTot = [log1.CUR2(:,5);log2.CUR2(:,5)];

% TimeRCIN = [log1.RCIN(:,2);log2.RCIN(:,2)];
% RCIN3 = [log1.RCIN(:,5);log2.RCIN(:,5)];

TimeCURR = (TimeCURR - TimeCURR(1))./1e6./60;



%%
% Volt = V.*100;
% TimeCURR = t;
% Curr = I2.*100;
% CurrTot = tot2;
% Plot_Off;

PLOT.Title = 'BATTERY VOLTAGE AND CURRENT';
% INFO = FMT_GetInfo(INFO,FMT);


% [ Volt, TimeCURR ] = Data_Trim(FMT,INFO,'CURR','Volt',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
% [ Curr, ~ ] = Data_Trim(FMT,INFO,'CURR','Curr',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
% [ CurrTot, ~ ] = Data_Trim(FMT,INFO,'CURR','CurrTot',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
% [ Throttle, ~ ] = Data_Trim(FMT,INFO,'CURR','Throttle',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
% [ RCIN3, TimeRCIN ] = Data_Trim(FMT,INFO,'RCIN','C3',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);
%[ RCOU3, TimeRCOU ] = Data_Trim(FMT,INFO,'RCOU','Ch3',PLOT.Segment,PLOT.isArmed,PLOT.isFlying);






% figure
% set(gcf,'GraphicsSmoothing','on')
clf

set(gcf, 'Position', [200 200 1100 650])
set(gcf,'Color',[1 1 1]);

ax1 = subplot(3,1,1);
Plot_Format(gca);

hold on
yyaxis left
plot(TimeCURR,[Volt]);
ylabel('VOLTAGE [V]');
ylim([2 14])
yyaxis right
plot(TimeCURR,[Volt]);
ylabel('VOLTAGE [V]');
ylim([2 14])
hold off

xlabel('TIME [min]');


ax2 = subplot(3,1,2);
Plot_Format(gca);

hold on
yyaxis left
plot(TimeCURR,[Curr]);
ylabel('CURRENT [A]');
set(gca,'YTick',[0:0.2:1]);
yyaxis right
plot(TimeCURR,[Curr]);
ylabel('CURRENT [A]');
set(gca,'YTick',[0:0.2:1]);
hold off

xlabel('TIME [min]');

ax3 = subplot(3,1,3);
Plot_Format(gca);
hold on
yyaxis left
plot(TimeCURR, CurrTot);
ylabel('DISCHARGE CAPACITY [mAh]');
xlabel('TIME [min]');
set(gca,'YTick',[0:200:1000]);
yyaxis right
plot(TimeCURR, CurrTot);
ylabel('DISCHARGE CAPACITY [mAh]');
set(gca,'YTick',[0:200:1000]);
hold off

linkaxes([ax1,ax2,ax3],'x')

INFO.GNDTEST = 1;
INFO.Date = '2016-08-24';
PLOT.Segment = 0;
INFO.Aircraft = '1000mAh/3S';


INFO.MSG(1).Type = 'BATT';
INFO.MSG(1).Text = '1000mAh/3S Battery Discharge Test';

PLOT.MSG = MSG_Filter(INFO,'BATT');

Plot_Create(INFO,PLOT,'BatteryMonitor');


% close all
% Plot_On;
