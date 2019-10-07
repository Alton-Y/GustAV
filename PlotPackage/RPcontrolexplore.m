function [] = RPcontrolexplore(INFO,FMT,GND,fig)
%plots info related to Roll/Pitch controllers

fig.Name = 'Roll/Pitch Controller Info';
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
hold on
try
    p=plot(FMT.ATRP.TimeS(FMT.ATRP.Type == 0),FMT.ATRP.P(FMT.ATRP.Type == 0),'-k');
%     i=plot(FMT.PIDR.TimeS,FMT.PIDR.P,'--r');
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
yyaxis left

s2=subplot(4,1,2);
yyaxis left
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
ax = gca;
ax.YColor = 'k';
ylabel('Angle (deg)')
axis tight
grid on
box on

yyaxis right
hold on

Ip=plot(FMT.PIDR.TimeS,FMT.PIDR.I,'--r');
ylabel('Integrator');
legend([dem,ach,Ip],{'Demanded Roll','Achieved Roll','Roll Integrator'},'location','northwest')
ax = gca;
ax.YColor = 'r';
% set(gca,'XTickMode','manual');
% datetick('x','HH:MM:SS')

% set(gca,'XTickMode','manual');
yyaxis left

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
yyaxis left

s4= subplot(4,1,4);
yyaxis left
hold on
temp = FMT.CTUN.NavPitch;
temp(mode == 0) = nan;
dem=plot(FMT.CTUN.TimeS,temp,'-k');
clear temp
temp = FMT.CTUN.Pitch;
temp(mode == 0) = nan;
ach=plot(FMT.CTUN.TimeS,temp,'-b');
ylabel('Angle (deg)')
% set(gca,'XTickMode','manual');
% datetick('x','HH:MM:SS')
axis tight
grid on
box on
ax = gca;
ax.YColor = 'k';

yyaxis right
hold on
Ip=plot(FMT.PIDP.TimeS,FMT.PIDP.I,'--r');
axis tight
ax = gca;
ax.YColor = 'r';
ylabel('Integrator');

legend([dem,ach,Ip],{'Demanded Pitch','Achieved Pitch','Pitch Integrator'},'location','northwest')
linkaxes([s1,s2,s3,s4],'x');
try
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3 s4