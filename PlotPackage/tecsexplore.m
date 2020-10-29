function tecsexplore(INFO,FMT,GND,fig)
fig.Name = 'TECS Explore';
clf(fig);
try
    s1=subplot(4,1,1);
    hold on
    hdem=plot(FMT.TECS.TimeS,FMT.TECS.hdem,'-k');
    h=plot(FMT.TECS.TimeS,FMT.TECS.h,'--b');
    legend([hdem,h],{'Demanded ALT','Actual ALT'},'location','northwest');
    ylabel('m AGL');
    axis tight
    grid on
    box on
catch
end
s2=subplot(4,1,2);
hold on

% find primary sensor data
try
idxp = FMT.ARSP.Primary==0;
catch
  idxp = FMT.ARSP.Pri==0;  
end
allspeed = nan(size(FMT.ARSP.Airspeed));
allspeed(idxp) =FMT.ARSP.Airspeed(idxp);
try
    idxp2 = FMT.ASP2.Primary ==1;
    allspeed(idxp2) =FMT.ASP2.Airspeed(idxp2);
catch
end

raw = plot(FMT.ARSP.TimeS,allspeed,'.-k');
legend([raw],'RAW EAS');
try
avg = plot(FMT.CTUN.TimeS,FMT.CTUN.Aspd,'.-g');
legend([raw,avg],{'RAW EAS','ARSPD EST'},'location','northwest');
catch
end
try
demtas=plot(FMT.TECS.TimeS,FMT.TECS.spdem,'-k');
tas=plot(FMT.TECS.TimeS,FMT.TECS.sp,'.--b');
legend([raw,avg,tas,demtas],{'RAW EAS','ARSPD EST','TAS Filt','Dem TAS'});
catch
end

try
rat = FMT.TECS.sp./interp1(FMT.CTUN.TimeS,FMT.CTUN.Aspd,FMT.TECS.TimeS);
demeas = plot(FMT.TECS.TimeS,FMT.TECS.spdem./rat,'--');
legend([raw,avg,tas,demtas,demeas],{'RAW EAS','ARSPD EST','TAS Filt','Dem TAS','Dem EAS'});
catch
end
% yyaxis right 
% plot(FMT.TEC2.TimeS,FMT.TEC2.KErr); 
%  logging.SKE_error = _SKE_dem - _SKE_est;
%_SKE_dem = 0.5f * _TAS_dem_adj * _TAS_dem_adj;  
%_SKE_est = 0.5f * _TAS_state * _TAS_state;
% grid on

% yyaxis left


ylabel('m/s');
axis tight
grid on
box on

s3=subplot(4,1,3);
hold on
thr=plot(FMT.RCOU.TimeS,FMT.RCOU.C3,'-k');

legend([thr],{'THR OUT'},'location','northwest');
ylabel('PWM');
axis tight
grid on
box on

yyaxis right
hold on
temp = FMT.CTUN.NavPitch;
mode = fcnGETMODE(INFO,FMT.CTUN.TimeS);
temp(mode == 0) = nan;
dem=plot(FMT.CTUN.TimeS,temp,'--b');
clear temp
temp = FMT.CTUN.Pitch;
temp(mode == 0) = nan;
ach=plot(FMT.CTUN.TimeS,temp,'-b');
legend([thr,dem,ach],{'THR OUT','Dem Pitch','Achieved Pitch'});
ylabel('Pitch Angle (deg)')


s4=subplot(4,1,4);
hold on
notes=plot(FMT.TECS.TimeS,FMT.TECS.f,'*k');

legend([notes],{'TECS FLAG'},'location','northwest');
ylabel('FLAG');
axis tight
grid on
box on
% 
% yyaxis right
% hold on
% temp = FMT.CTUN.NavPitch;
% mode = fcnGETMODE(INFO,FMT.CTUN.TimeS);
% temp(mode == 0) = nan;
% dem=plot(FMT.CTUN.TimeS,temp,'--b');
% clear temp
% temp = FMT.CTUN.Pitch;
% temp(mode == 0) = nan;
% ach=plot(FMT.CTUN.TimeS,temp,'-b');
% legend([thr,dem,ach],{'THR OUT','Dem Pitch','Achieved Pitch'});
% ylabel('Pitch Angle (deg)')



try
    linkaxes([s1,s2,s3,s4],'x');
end
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3