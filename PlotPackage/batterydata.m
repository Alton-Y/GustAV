function batterydata(INFO,FMT,GNDSTN,fig)
fig.Name = 'Battery Data';
clf(fig);

s1=subplot(3,1,1);
hold on
v=plot(FMT.CURR.TimeS,FMT.CURR.Volt,'-k');
v2=plot(FMT.CUR2.TimeS,FMT.CUR2.Volt,'-b');
legend([v,v2],{'Voltage (Main Battery)','Voltage (Avionics Battery)'},'location','northwest');
ylabel('V');
axis tight
grid on
box on


s2=subplot(3,1,2);
hold on
a=plot(FMT.CURR.TimeS,FMT.CURR.Curr,'-k');
a2=plot(FMT.CUR2.TimeS,FMT.CUR2.Curr,'-b');
legend([a,a2],{'Amps (Main Battery)','Amps (Avionics Battery)'},'location','northwest');
ylabel('A');
axis tight
grid on
box on

s3=subplot(3,1,3);
hold on
a=plot(FMT.CURR.TimeS,FMT.CURR.CurrTot,'-k');
a2=plot(FMT.CUR2.TimeS,FMT.CUR2.CurrTot,'-b');
legend([a,a2],{'Total Draw (Main Battery)','Total Draw (Avionics Battery)'},'location','northwest');
ylabel('mAh');
axis tight
grid on
box on

linkaxes([s1,s2,s3],'x');

xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
clear s1 s2 s3

end