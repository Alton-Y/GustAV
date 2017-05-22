function [] = tuningdata(INFO,FMT,GND,fig)
%plots autotune info

fig.Name = 'AutoTune Info';
clf(fig);

s1=subplot(4,1,1);
hold on
yyaxis left
try
    dem=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 0),FMT.ATRP.Demanded(FMT.ATRP.Type == 0),'.k');
    ach=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 0),FMT.ATRP.Achieved(FMT.ATRP.Type == 0),'.b');
catch
end
ylabel('Rate (deg/s)')
ax = gca;
ax.YColor = 'k';
yyaxis right
try
    p=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 0),FMT.ATRP.P(FMT.ATRP.Type == 0),'-k');
    legend([dem,ach,p],{'Demanded Roll Rate','Achieved Roll Rate','P Gain'},'location','northwest')
catch
end
% set(gca,'XTickMode','manual');
% datetick('x','HH:MM:SS')
axis tight
ylabel('P Gain')
% xlim([minx,maxx]);
ax = gca;
ax.YColor = 'k';
% set(gca,'XTickMode','manual');
% tickdata = get(gca,'XTick');
grid on
box on

s2=subplot(4,1,2);
hold on
mode = fcnGETMODE(INFO,FMT.CTUN.TimeS);
temp = FMT.CTUN.NavRoll;
temp(mode == 0) = nan;
dem=plot(FMT.CTUN.TimeS,temp,'-k');
clear temp
temp = FMT.CTUN.Roll;
temp(mode == 0) = nan;
ach=plot(FMT.CTUN.TimeS,temp,'-b');
clear temp
legend([dem,ach],{'Demanded Roll','Achieved Roll'},'location','northwest')
ylabel('Angle (deg)')
% set(gca,'XTickMode','manual');
% datetick('x','HH:MM:SS')
axis tight
% set(gca,'XTickMode','manual');
grid on
box on

s3=subplot(4,1,3);
hold on
yyaxis left
try
    dem=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 1),FMT.ATRP.Demanded(FMT.ATRP.Type == 1),'.k');
    ach=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 1),FMT.ATRP.Achieved(FMT.ATRP.Type == 1),'.b');
catch
end
ylabel('Rate (deg/s)')
ax = gca;
ax.YColor = 'k';
yyaxis right
try
    p=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 1),FMT.ATRP.P(FMT.ATRP.Type == 1),'-k');
    legend([dem,ach,p],{'Demanded Pitch Rate','Achieved Pitch Rate','P Gain'},'location','northwest')
catch
end
% set(gca,'XTickMode','manual');
axis tight
% xlim([minx,maxx]);
% set(gca,'XTick',tickdata)
% datetick('x','HH:MM:SS','keeplimits')
ylabel('P Gain')
ax = gca;
ax.YColor = 'k';
grid on
box on

s4= subplot(4,1,4);
hold on
temp = FMT.CTUN.NavPitch;
temp(mode == 0) = nan;
dem=plot(FMT.CTUN.TimeS,temp,'-k');
clear temp
temp = FMT.CTUN.Pitch;
temp(mode == 0) = nan;
ach=plot(FMT.CTUN.TimeS,temp,'-b');
legend([dem,ach],{'Demanded Pitch','Achieved Pitch'},'location','northwest')
ylabel('Angle (deg)')
% set(gca,'XTickMode','manual');
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

linkaxes([s1,s2,s3,s4],'x');
try
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3 s4