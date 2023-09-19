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
raw = plot(FMT.ARSP(1).TimeS(FMT.ARSP(1).Pri==0),FMT.ARSP(1).Airspeed(FMT.ARSP(1).Pri==0),'.-k');
try
raw2 = plot(FMT.ARSP(2).TimeS(FMT.ARSP(1).Pri==1),FMT.ARSP(2).Airspeed(FMT.ARSP(2).Pri==1),'.m');
end
avg = plot(FMT.CTUN.TimeS,FMT.CTUN.As,'.-g');
legend([raw,avg],{'RAW EAS','EAS'},'location','northwest');

try
demtas=plot(FMT.TECS.TimeS,FMT.TECS.spdem,'-r');
tas=plot(FMT.TECS.TimeS,FMT.TECS.sp,'.--b');
legend([raw,avg,tas,demtas],{'RAW EAS','EAS','TAS Filt','Dem TAS'});
catch
end

try
    
% rat = FMT.TECS.sp./interp1(FMT.CTUN.TimeS,FMT.CTUN.As,FMT.TECS.TimeS);
rat = interp1(FMT.CTUN.TimeS,FMT.CTUN.E2T,FMT.TECS.TimeS);
demeas = plot(FMT.TECS.TimeS,FMT.TECS.spdem./rat,'--r');

legend([raw,avg,tas,demtas,demeas],{'RAW EAS','EAS','TAS Filt','Dem TAS','Dem EAS'});
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
try
notes=plot(FMT.TECS.TimeS,FMT.TECS.f,'*k');

legend([notes],{'TECS FLAG'},'location','northwest');
ylabel('FLAG');
catch
end
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