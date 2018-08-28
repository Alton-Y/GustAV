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
    
    % find primary sensor data
    idxp = FMT.ARSP.Primary==0;
    allspeed = nan(size(FMT.ARSP.Airspeed));
    allspeed(idxp) =FMT.ARSP.Airspeed(idxp);
    try
        idxp2 = FMT.ASP2.Primary ==1;
        allspeed(idxp2) =FMT.ASP2.Airspeed(idxp2);
    catch
    end
    
    sdem=plot(FMT.TECS.TimeS,FMT.TECS.spdem,'-k');
    s=plot(FMT.TECS.TimeS,FMT.TECS.sp,'.--b');
    raw  = plot(FMT.ARSP.TimeS,allspeed,'.-k');
    ctuna = plot(FMT.CTUN.TimeS,FMT.CTUN.Aspd,'.-g');
    legend([sdem,s,raw,ctuna],{'Demanded ARSP','Actual TAS','RAW EAS','ARSP EST'},'location','northwest');
    ylabel('m/s');
    axis tight
    grid on
    box on
catch
end
s3=subplot(3,1,3);
hold on
thr=plot(FMT.RCOU.TimeS,FMT.RCOU.C3,'-k');
legend([thr],{'THR OUT'},'location','northwest');
ylabel('PWM');
axis tight
grid on
box on

try
    linkaxes([s1,s2,s3],'x');
end
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3