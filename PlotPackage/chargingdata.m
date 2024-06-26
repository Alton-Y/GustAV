function [] = motordata(INFO,FMT,GND,TEMPLOG,fig)
%plots charging data

fig.Name = 'Charging Data';
clf(fig);
%%
s1 = subplot(4,1,1);
hold on

% find primary sensor data
if isfield(FMT,'CESC')
esc=plot(FMT.CESC.TimeS,FMT.CESC.Curr.*FMT.CESC.Voltage,'.b');
else
esc=plot(FMT.ESC(3).TimeS,FMT.ESC(3).Curr.*FMT.ESC(3).Volt,'.b');
    
end
draw=plot(FMT.BAT(1).TimeS,FMT.BAT(1).Curr.*FMT.BAT(1).Volt,'.r');


% ppv2=plot(TEMPLOG.TimeS,TEMPLOG.MPPT.PPV,'.-m');
% ppv=plot(FMT.BAT3.TimeS,-(FMT.BAT3.Curr.*100 - fix(FMT.BAT3.Curr).*100).*4,'.k');
% mpptp=plot(FMT.BAT3.TimeS,FMT.BAT3.Volt.*fix((65534-FMT.BAT3.CurrTot)./100).*100./1000,'.b');

if isfield(FMT,'BCL3')
mpptp = plot(FMT.BCL3.TimeS,FMT.BCL3.V4./100 .* FMT.BCL3.V5./10);
else
 mpptp = plot(FMT.BCL(3).TimeS,FMT.BCL(3).V10/100);
end
grid on
box on
ylabel('Power [W]');

legend([esc,mpptp,draw],{'ESC','MPPT-Charge','Total Load'})
%%
s4 = subplot(4,1,4);

if isfield(FMT,'BCL3')
discurr = interp1(FMT.BAT.TimeS,FMT.BAT.Curr,FMT.BCL3.TimeS)-...
    FMT.BCL3.V5./10;
discurrfig= plot(FMT.BCL3.TimeS,discurr,'.');
grid on
box on
ylabel('[A]');

yyaxis right
plot(FMT.BCL3.TimeS,cumtrapz(FMT.BCL3.TimeS,discurr)./3600 *1000);
legend('Battery discharge current','Total mAh out of Battery','Location','northwest');
ylabel('mAh')
xlabel('Time, s')

end
% hold on
% mpptvolt = plot(FMT.BAT3.TimeS,(FMT.BAT3.Volt),'.b');
% systemvolt = plot(FMT.BAT.TimeS,FMT.BAT.Volt,'.k');
% vpv = plot(TEMPLOG.TimeS,TEMPLOG.MPPT.VPV,'.r');
% legend([mpptvolt,systemvolt,vpv],{'MPPT Charge','System','Solar Array'})
% grid on
% box on
% ylabel('[V]');
%%
s3 = subplot(4,1,3);
hold on

if isfield(FMT,'BCL3')
loadcurr = plot(FMT.BAT.TimeS,FMT.BAT.Curr,'.');
esccurr = plot(FMT.CESC.TimeS,FMT.CESC.Curr,'.');

% mpptcurr = plot(TEMPLOG.TimeS,TEMPLOG.MPPT.CURR,'.');
% mpptcurr = plot(FMT.BAT3.TimeS,fix((65534-FMT.BAT3.CurrTot)/100)/10,'.');
mpptcurr = plot(FMT.BCL3.TimeS,FMT.BCL3.V5./10);


legend('load','esc','mppt');
ylabel('Current [A]');
grid on 
box on
end
%%
s2 = subplot(4,1,2);

if isfield(FMT,'BCL3')
batpow=interp1(FMT.BAT.TimeS,(FMT.BAT.Curr.*FMT.BAT.Volt),FMT.BCL3.TimeS) -...
    (FMT.BCL3.V4./100 .* FMT.BCL3.V5./10);
%     FMT.BAT3.Volt.*fix((65534-FMT.BAT3.CurrTot)./100).*100./1000;
%     (-(FMT.BAT3.Curr.*100 - fix(FMT.BAT3.Curr).*100).*4);
batpowfig = plot(FMT.BCL3.TimeS,batpow,'.k');
else
    batpow=interp1(FMT.BAT(1).TimeS,(FMT.BAT(1).Curr.*FMT.BAT(1).Volt),FMT.BCL(3).TimeS) -...
    (FMT.BCL(3).V10./100);
batpowfig = plot(FMT.BCL(3).TimeS,batpow,'.k');
end


ylabel('[W]');
grid on 
box on

yyaxis right
if isfield(FMT,'BCL3')
plot(FMT.BCL3.TimeS,cumtrapz(FMT.BCL3.TimeS,batpow)./3600);
else
  plot(FMT.BCL(3).TimeS,cumtrapz(FMT.BCL(3).TimeS,batpow)./3600);
  
end
legend('Battery discharge power','Total Energy out of Battery','Location','northwest');
ylabel('Wh')
linkaxes([s1,s2,s3,s4],'x');
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3 s4

% 
% 
% hold on
% 
% mpptp = plot((FMT.BCL3.TimeLOCAL-(4/24)),FMT.BCL3.V4./100 .* FMT.BCL3.V5./10,'.');
% mpptsmooth = plot((FMT.BCL3.TimeLOCAL-(4/24)),smooth(FMT.BCL3.V4./100 .* FMT.BCL3.V5./10,1000,'moving'),'.');
% mpptsmooth = plot((FMT.BCL3.TimeLOCAL-(4/24)),smooth(FMT.BCL3.V4./100 .* FMT.BCL3.V5./10,5000,'moving'),'.');
% 
text(INFO.segment.startTimeLOCAL-(4/24),zeros(length(INFO.segment.startTimeLOCAL-(4/24)),1),INFO.segment.modeAbbr,'Rotation',90);
text(INFO.segment.startTimeS,zeros(length(INFO.segment.startTimeS),1),INFO.segment.modeAbbr,'Rotation',90);

% grid on
% box on
% legend('MPPT Charge Power','Smoothed','More Smoothed')
% ylabel('Watts')
% xlabel('Local Time')
% datetick('x','HH:MM:SS')
% 
% format long
% xticks('auto')
% xt = xticks
% xticks(linspace(xt(1),xt(5),30));
