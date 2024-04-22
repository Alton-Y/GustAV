function tecs2explore(INFO,FMT,fig)
fig.Name = 'TECS 2 Explore';
clf(fig);

    s1=subplot(5,1,1);
    hold on
    dh=plot(FMT.TECS.TimeS,FMT.TECS.dh,'.k'); %climb rate
    dhdem=plot(FMT.TECS.TimeS,FMT.TECS.dhdem,'.b'); %climb rate demand
    
    
legend([dh,dhdem],{'climb rate', 'demanded climb rate'},'location','northwest');
    axis tight
    grid on
    box on
    ylabel('m/s/s')
    
s2=subplot(5,1,2);
hold on


try
raw =plot(FMT.TECS.TimeS,FMT.TECS.dsp,'.k'); %x-axis acceleration estimate ("delta-speed")
dem =plot(FMT.TECS.TimeS,FMT.TECS.dspdem,'.b'); %x-axis acceleration estimate ("delta-speed")
 
legend([raw,dem],{'x accel', 'demanded x accel'},'location','northwest');
catch
end

ylabel('m/s/s');
axis tight
grid on
box on

s3=subplot(5,1,3);
hold on
plot(FMT.TEC3.TimeS,FMT.TEC3.TEE,'.');
yyaxis right
thr=plot(FMT.TEC3.TimeS,FMT.TEC3.TEDE,'.');

legend({'Energy Error',' Total Energy Rate Error'},'location','northwest');
ylabel('');
axis tight
grid on
box on


s4=subplot(5,1,4);
hold on
try
    k=0.0034
thr=plot(FMT.TEC3.TimeS,FMT.TEC3.FFT,'.');
% yyaxis right
ptch =plot(FMT.TEC3.TimeS,FMT.TEC3.I,'.');
plot(FMT.TEC3.TimeS,FMT.TEC3.TEDE.*0.3.*k);
plot(FMT.TEC3.TimeS,FMT.TEC3.TEE.*k);
legend({'ff throttle','thr int','thrdamp','p'},'location','northwest');

catch
end
axis tight
grid on
box on


s5=subplot(5,1,5);
hold on
plot(FMT.TECS.TimeS,FMT.TECS.th)
k=0.0034
% _throttle_dem = (_STE_error + STEdot_error * throttle_damp) * K_STE2Thr + ff_throttle;
thrcalc =( (FMT.TEC3.TEDE.*0.3+FMT.TEC3.TEE).*k + FMT.TEC3.FFT +FMT.TEC3.I);
thrcalc(thrcalc<0)=0
plot(FMT.TEC3.TimeS,thrcalc)
legend('thr','calced thr')
% try
% ke=plot(FMT.TEC2.TimeS,FMT.TEC2.KErr,'.k');
% 
% pe =plot(FMT.TEC2.TimeS,FMT.TEC2.PErr,'.b');
% 
% legend([ke, pe],{'Kinetic E Err.','Potential E Err.'},'location','northwest');
% 
% catch
% end
axis tight
grid on
box on


% s6=subplot(6,1,6);
% hold on
% try
% raw =plot(FMT.TEC2.TimeS,FMT.TEC2.EDelta,'.b'); %EDelta: current error in speed/balance weighting
% 
% 
% legend([raw],{'error in speed/balance weighting'},'location','northwest');
% 
% catch
% end
% axis tight
% grid on
% box on


try
    linkaxes([s1,s2,s3,s4,s5],'x');
end
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3