function [] = motordata(INFO,FMT,GND,TEMPLOG,fig)
%plots charging data

fig.Name = 'Charging Data';
clf(fig);
%%
s1 = subplot(4,1,1);
hold on

% find primary sensor data

% esc=plot(FMT.CESC.TimeS,FMT.CESC.Curr.*FMT.CESC.Voltage,'.b');
draw=plot(FMT.BAT.TimeS,FMT.BAT.Curr.*FMT.BAT.Volt,'.r');


% ppv2=plot(TEMPLOG.TimeS,TEMPLOG.MPPT.PPV,'.-m');
ppv=plot(FMT.BAT3.TimeS,-(FMT.BAT3.Curr.*100 - fix(FMT.BAT3.Curr).*100).*4,'.k');
mpptp=plot(FMT.BAT3.TimeS,FMT.BAT3.Volt.*fix((65534-FMT.BAT3.CurrTot)./100).*100./1000,'.b');
grid on
box on
ylabel('Power [W]');

legend([ppv,mpptp,draw],{'MPPT-Solar','MPPT-Charge','Total Load'})
%%
s4 = subplot(4,1,4);
discurr = interp1(FMT.BAT.TimeS,FMT.BAT.Curr,FMT.BAT3.TimeS)-...
    fix((65534-FMT.BAT3.CurrTot)/100)/10;
discurrfig= plot(FMT.BAT3.TimeS,discurr,'.');
grid on
box on
ylabel('[A]');

yyaxis right
plot(FMT.BAT3.TimeS,cumtrapz(FMT.BAT3.TimeS,discurr)./3600 *1000);
legend('Battery discharge current','Total mAh @ Battery','Location','northwest');
ylabel('mAh')
xlabel('Time, s')
% hold on
% mpptvolt = plot(FMT.BAT3.TimeS,(FMT.BAT3.Volt),'.b');
% systemvolt = plot(FMT.BAT.TimeS,FMT.BAT.Volt,'.k');
% vpv = plot(TEMPLOG.TimeS,TEMPLOG.MPPT.VPV,'.r');
% legend([mpptvolt,systemvolt,vpv],{'MPPT Charge','System','Solar Array'})
% grid on
% box on
% ylabel('[V]');

s3 = subplot(4,1,3);
hold on
loadcurr = plot(FMT.BAT.TimeS,FMT.BAT.Curr,'.');
esccurr = plot(FMT.CESC.TimeS,FMT.CESC.Curr,'.');

% mpptcurr = plot(TEMPLOG.TimeS,TEMPLOG.MPPT.CURR,'.');
mpptcurr = plot(FMT.BAT3.TimeS,fix((65534-FMT.BAT3.CurrTot)/100)/10,'.');

legend('load','esc','mppt');
ylabel('Current [A]');
grid on 
box on

s2 = subplot(4,1,2);

batpow=interp1(FMT.BAT.TimeS,(FMT.BAT.Curr.*FMT.BAT.Volt),FMT.BAT3.TimeS) -...
    FMT.BAT3.Volt.*fix((65534-FMT.BAT3.CurrTot)./100).*100./1000;
%     (-(FMT.BAT3.Curr.*100 - fix(FMT.BAT3.Curr).*100).*4);
batpowfig = plot(FMT.BAT3.TimeS,batpow,'.k');

ylabel('[W]');
grid on 
box on

yyaxis right
plot(FMT.BAT3.TimeS,cumtrapz(FMT.BAT3.TimeS,batpow)./3600);
legend('Battery discharge power','Total Energy @ Battery','Location','northwest');
ylabel('Wh')
linkaxes([s1,s2,s3,s4],'x');
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3 s4