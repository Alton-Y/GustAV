function hardware(INFO,FMT,TLOG,fig)
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
    yyaxis left
a=plot(FMT.PM.TimeS,FMT.PM.LogDrop,'.-k');
ax = gca;
ax.YColor = 'k';
axis tight
catch
    warning('No logs dropped data available');
end
ylabel('Logs Dropped');
try
    yyaxis right
    b = plot(TLOG.sensors.LOGGING.TimeS,TLOG.sensors.LOGGING.health,'.-b');
    ylabel('Log Health (MAVLINK)');
    ylim([-0.25 1.25]);
    ax = gca;
ax.YColor = 'b';
catch
    warning('No TLOG data');
end



grid on
box on
% legend([a],{'Amps (Main Battery)'},'location','northwest');


s4 = subplot(4,1,4);
hold on
%plot messages sent to GS (note these are from the pixhawk, not the tlog
plot(FMT.MSG.TimeS,ones(length(FMT.MSG.TimeS),1),'.r');
text(FMT.MSG.TimeS,ones(length(FMT.MSG.TimeS),1),FMT.MSG.MessageStr,'Rotation',90)

%plot mode
plot(INFO.segment.startTimeS,zeros(length(INFO.segment.startTimeS),1),'.b');
text(INFO.segment.startTimeS,zeros(length(INFO.segment.startTimeS),1),INFO.segment.modeAbbr,'Rotation',90);

grid on
box on
axis tight
ylim([0,4]);
linkaxes([s1,s2,s3,s4],'x');
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
%  
end
clear s1 s2 s3

end