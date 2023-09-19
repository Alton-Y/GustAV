
clf

s1=subplot(4,1,1)
hold on
plot(FMT.XKF1(1).TimeS,-FMT.XKF1(1).VD,'.')
% plot(FMT.TECS.TimeS,FMT.TECS.dh,'.')
% plot(FMT.TECS.TimeS,FMT.TECS.dhdem,'.')
ylabel(['crate'])
grid on

s2=subplot(4,1,2)
hold on

plot(FMT.ATT(1).TimeS,FMT.ATT(1).Pitch,'.')
plot(FMT.ATT.TimeS,FMT.ATT.DesPitch,'.')
legend('Pitch','DesPitch')
ylabel('pitch')
grid on

s3=subplot(4,1,3)
hold on
plot(FMT.CTUN(1).TimeS,FMT.CTUN(1).As,'.')
% plot(FMT.TECS.TimeS,FMT.TECS.spdem,'.')
ylabel('arsp')
grid on

rll=interp1(FMT.ATT(1).TimeS,FMT.ATT(1).Roll,FMT.CTUN.TimeS);
idx =abs(rll)<2;
s4=subplot(4,1,4)
% thrp=(FMT.RCOU(1).C3-1500)./(400);
thrp=(FMT.CTUN.ThO)
hold on
plot(FMT.CTUN(1).TimeS(),thrp(),'.')
plot(FMT.CTUN(1).TimeS(idx),thrp(idx),'.')
ylabel('thr')
grid on

linkaxes([s1,s2,s3,s4],'x')