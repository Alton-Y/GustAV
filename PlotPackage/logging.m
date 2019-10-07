function logging(INFO,FMT,TLOG,fig)
fig.Name = 'Dataflash Log Data';
clf(fig);

%dataflash log issues

s1=subplot(4,1,1);
hold on
v=plot(FMT.DSF.TimeS,FMT.DSF.Blk,'.b');
axis tight
ylabel('Blocks')
grid on
box on
axis tight

%%
s2=subplot(4,1,2);
hold on
v=plot(FMT.DSF.TimeS,FMT.DSF.Bytes,'.b');
axis tight
ylabel('Bytes Written')
grid on
box on
axis tight

%%
s3=subplot(4,1,3);
hold on
try
    yyaxis left
    if isfield(FMT.PM,'LogDrop') == 1
a=plot(FMT.PM.TimeS,FMT.PM.LogDrop,'.-k');
    else
        a=plot(FMT.DSF.TimeS,FMT.DSF.Dp,'.-k');
    end
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

%%
s4 = subplot(4,1,4);
hold on
v5=plot(FMT.DSF.TimeS,FMT.DSF.FMn,'.k');
v6=plot(FMT.DSF.TimeS,FMT.DSF.FMx,'.b');
v7=plot(FMT.DSF.TimeS,FMT.DSF.FAv,'.r');

axis tight
ylabel('Buffer Space')
grid on
box on

linkaxes([s1,s2,s3,s4],'x');
% try
%     xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
% catch
% %  
% end
clear s1 s2 s3

end