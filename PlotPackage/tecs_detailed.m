% TEC3

figure(15)
clf(15)
s1=subplot(4,1,1)
hold on
% plot(FMT.TEC3.TimeS,FMT.TEC3.KED,'.')
% plot(FMT.TEC3.TimeS,FMT.TEC3.KEDD,'.')
plot(FMT.TEC2.TimeS,FMT.TEC2.EBDD,'.')
plot(FMT.TEC2.TimeS,FMT.TEC2.EBDE,'.')
legend('Energy Dot Demand  SEB_dot_dem','Energy Dot SEB_dot'); 
grid on 
box on

s2=subplot(4,1,2)
hold on
plot(FMT.TEC2.TimeS,FMT.TEC2.EBD,'.')
plot(FMT.TEC2.TimeS,FMT.TEC2.EBE,'.')
legend('Energy Dem SEB_dem','Energy meas SEB_meas')
grid on 
box on

s3=subplot(4,1,3)
hold on
plot(FMT.TEC2.TimeS,FMT.TEC2.EBDDT,'.b')
plot(FMT.TEC2.TimeS,FMT.TEC2.I,'.')
plot(FMT.TEC2.TimeS,FMT.TEC2.KI,'.')
plot(FMT.TEC2.TimeS,FMT.TEC2.EBDD,'.')
plot(FMT.TEC2.TimeS,(FMT.TEC2.EBDD-FMT.TEC2.EBDE).*0.3,'.')
plot(FMT.TEC2.TimeS,FMT.TEC2.EBDD+(FMT.TEC2.EBDD-FMT.TEC2.EBDE).*0.3,'-')
% plot(FMT.TEC3.TimeS,FMT.TEC3.FFT.*100,'.')

legend('FF + Damp ', 'Rate I','Ki','FF','Damp', ...
    'FF+Damp calc')
grid on 
box on

s4=subplot(4,1,4)
hold on

plot(FMT.TECS.TimeS,FMT.TECS.ph.*180./pi,'.');
plot(FMT.ATT.TimeS,FMT.ATT.Pitch,'.');
%    _pitch_dem_unc = (SEBdot_dem_total + _integSEBdot + _integKE) / gainInv
% gainInv = (_TAS_state * GRAVITY_MSS);
plot(FMT.TEC2.TimeS,(FMT.TEC2.EBDDT+FMT.TEC2.I+FMT.TEC2.KI)./(12.*9.81).*180./pi)
legend('pitch demand','pitch')
grid on 
box on

linkaxes([s1,s2,s3,s4],'x')