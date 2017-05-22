function tecsexplore(INFO,FMT,GND,fig)
fig.Name = 'TECS Explore';
clf(fig);
try
    s1=subplot(3,1,1);
    hold on
    hdem=plot(FMT.TECS.TimeS,FMT.TECS.hdem,'-k');
    h=plot(FMT.TECS.TimeS,FMT.TECS.h,'--b');
    legend([hdem,h],{'Demanded ALT','Actual ALT'},'location','northwest');
    ylabel('m AGL');
    axis tight
    grid on
    box on
    
    s2=subplot(3,1,2);
    hold on
    sdem=plot(FMT.TECS.TimeS,FMT.TECS.spdem,'-k');
    s=plot(FMT.TECS.TimeS,FMT.TECS.sp,'--b');
    legend([sdem,s],{'Demanded ARSP','Actual ARSP'},'location','northwest');
    ylabel('m/s');
    axis tight
    grid on
    box on
catch
end
s3=subplot(3,1,3);
hold on
thr=plot(FMT.RCOU.TimeS,FMT.RCOU.C3,'-k');
legend([thr],{'throttleOUT'},'location','northwest');
ylabel('Control OUT');
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