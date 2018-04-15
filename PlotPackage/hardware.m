function hardware(INFO,FMT,fig)
fig.Name = 'Hardware Data';
clf(fig);

% i2c errors, board and servo voltage, log drop, something about loops,
% todo: load was added after 3.8.4 and logdrop was removed? changed to DSF
% struct, but when will its be available?

s1=subplot(4,1,1);
hold on
v=plot(FMT.POWR.TimeS,FMT.POWR.Vcc,'-k');
vs= plot(FMT.POWR.TimeS,FMT.POWR.VServo,'b');
axis tight

ylabel('Voltage [V]');
grid on
box on

legend([v,vs],{'Board', 'Servo Rail'},'location','northwest');


s2=subplot(4,1,2);
hold on
try
a=plot(FMT.PM.TimeS,FMT.PM.Mem./1000,'-k');
catch
    warning('No memory data available');
end
axis tight
ylabel('Memory Available [KB]');
grid on
box on

s3=subplot(4,1,3);
hold on
try
a=plot(FMT.PM.TimeS,FMT.PM.LogDrop,'.k');
catch
    warning('No logs dropped data available');
end
axis tight
ylabel('Logs Dropped');
grid on
box on
% legend([a],{'Amps (Main Battery)'},'location','northwest');

linkaxes([s1,s2,s3],'x');
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3

end