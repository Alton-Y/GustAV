function batterydata(INFO,FMT,GND,fig)
fig.Name = 'Battery Data';
clf(fig);


s1=subplot(3,1,1);
hold on
v=plot(FMT.CURR.TimeS,FMT.CURR.Volt,'-k');
t1a = s1.YLim(1):s1.YLim(2); %create left axis y-tick before axis tight
yyaxis right
v2=plot(FMT.CUR2.TimeS,FMT.CUR2.Volt,'-b');
t1b = s1.YLim(1):0.2:s1.YLim(2); %create right axis y-tick before axis tight

axis tight

yyaxis left
s1.YLim(1) = s1.YLim(1)-diff(s1.YLim)/1.5;
s1.YTick = t1a; %apply left axis y-tick
ylabel('Voltage [V]');

yyaxis right
s1.YLim(2) = s1.YLim(2)+diff(s1.YLim)/1.5; %adjust right axis 
s1.YTick = t1b; %apply right axis y-tick
ylabel('Voltage [V]');

grid on
grid minor
box on
legend([v,v2],{'Voltage (Main Battery)','Voltage (Avionics Battery)'},'location','northwest');



s2=subplot(3,1,2);
hold on
a=plot(FMT.CURR.TimeS,FMT.CURR.Curr,'-k');
t2a = 0:10:s2.YLim(2); %create left axis y-tick before axis tight
s2.YLim(1) = s2.YLim(1)-diff(s2.YLim)/1.5;
yyaxis right
a2=plot(FMT.CUR2.TimeS,FMT.CUR2.Curr,'-b');
t2b = s2.YLim(1):0.5:s2.YLim(2); %create right axis y-tick before axis tight

axis tight

yyaxis left
s2.YLim(1) = s2.YLim(1);
s2.YTick = t2a; %apply left axis y-tick
ylabel('Current [A]');

yyaxis right
s2.YLim(2) = s2.YLim(2)+diff(s2.YLim)/1.5; %adjust right axis 
s2.YTick = t2b; %apply right axis y-tick
ylabel('Current [A]');

grid on
grid minor
box on
legend([a,a2],{'Amps (Main Battery)','Amps (Avionics Battery)'},'location','northwest');






s3=subplot(3,1,3);
hold on
a=plot(FMT.CURR.TimeS,FMT.CURR.CurrTot,'-k');
s3.YLim(2) = s3.YLim(2)*1;
yyaxis right
a2=plot(FMT.CUR2.TimeS,FMT.CUR2.CurrTot,'-b');
legend([a,a2],{'Total Draw (Main Battery)','Total Draw (Avionics Battery)'},'location','northwest');
ylabel('mAh');
axis tight
s3.YLim(2) = s3.YLim(2)*2;
grid on
box on




linkaxes([s1,s2,s3],'x');
try
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3

end