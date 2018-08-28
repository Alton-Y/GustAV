function [] = channeldata(INFO,FMT,GND,fig)
%plots channel data

fig.Name = 'Channel Data';
clf(fig);

s1 = subplot(3,1,1);
hold on

%airspeed
yyaxis left
% find primary sensor data
idxp = FMT.ARSP.Primary==0;
allspeed = nan(size(FMT.ARSP.Airspeed));
allspeed(idxp) =FMT.ARSP.Airspeed(idxp);
try
    idxp2 = FMT.ASP2.Primary ==1;
    allspeed(idxp2) =FMT.ASP2.Airspeed(idxp2);
catch
end

arsp = plot(FMT.ARSP.TimeS,allspeed,'.-k');
ylabel('Airspeed (m/s)');
axis tight
ax = gca;
ax.YColor = 'k';
yyaxis right
crt = plot(FMT.BARO.TimeS,FMT.BARO.CRt,'--b');
ylabel('Climb Rate (m/s)');
ax = gca;
ax.YColor = 'b';
axis tight
% datetick('x','HH:MM:SS')
axis tight
legend([arsp,crt],{'Airspeed', 'Climb Rate'},'location','northwest')
grid on
box on

s2 =subplot(3,1,2);
hold on
%aileron
ailin=plot(FMT.RCIN.TimeS,FMT.RCIN.C1,'--k');
ailou=plot(FMT.RCOU.TimeS,FMT.RCOU.C1,'.k');
%elevator
elvin=plot(FMT.RCIN.TimeS,FMT.RCIN.C2,'--b');
elvou=plot(FMT.RCOU.TimeS,FMT.RCOU.C2,'.b');
%rudder
rudin=plot(FMT.RCIN.TimeS,FMT.RCIN.C4,'--r');
rudou=plot(FMT.RCOU.TimeS,FMT.RCOU.C4,'.r');

legend([ailin,ailou,elvin,elvou,rudin,rudou],{'AIL IN','AIL OUT','ELE IN','ELE OUT','RUD IN','RUD OUT'},'location','northwest')
ylabel('PWM')
axis tight
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

s3 = subplot(3,1,3);
hold on
%throttle
thrin=plot(FMT.RCIN.TimeS,FMT.RCIN.C3,'--r');
throu=plot(FMT.RCOU.TimeS,FMT.RCOU.C3,'-r');
legend([thrin,throu],{'THR IN','THR OUT'},'location','northwest')
ylabel('PWM')
axis tight
% datetick('x','HH:MM:SS')
axis tight
grid on
box on

linkaxes([s1,s2,s3],'x');
try
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3 