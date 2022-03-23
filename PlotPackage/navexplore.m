function navexplore(INFO,FMT,fig)
fig.Name = 'NAV Explore';
clf(fig);
try
    s1=subplot(5,1,1);
    hold on
%     hdem=plot(FMT.NTUN.TimeS,wrapTo360(FMT.NTUN.TBrg),'-k');
    h=plot(FMT.NTUN.TimeS,wrapTo360(FMT.NTUN.NavBrg),'.');
%     x = plot(FMT.NTUN.TimeS,FMT.NTUN.XT,'--r');
    x = plot(FMT.GPS(1).TimeS,FMT.GPS(1).GCrs,'.');
    heading = plot(FMT.ATT.TimeS,FMT.ATT.Yaw,'.');
    
    legend([h,x,heading],{'Nav Brg','GPS Course','Heading'},'location','northwest');
    ylabel('deg');
    axis tight
    grid on
    box on
catch
end
s2=subplot(5,1,2);

hold on
nroll = plot(FMT.CTUN.TimeS,FMT.CTUN.NavRoll,'.');
roll = plot(FMT.CTUN.TimeS,FMT.CTUN.Roll,'.');
    grid on
    box on

legend('Nav Roll','Roll')
s3=subplot(5,1,4);
%airspeed
% yyaxis left
hold on
arsp = plot(FMT.CTUN.TimeS,FMT.CTUN.As,'.');
arsp_g = plot(FMT.GPS(1).TimeS,FMT.GPS(1).Spd,'.');
% arsp_avt = plot(AVT.OUT.TimeS, AVT.OUT.ARSP, '-r');


axis tight
ylabel('m/s');
% ax = gca;
% ax.YColor = 'k';
legend([arsp,arsp_g],{'Airspeed','GND Speed'});
grid on 
box on

s4=subplot(5,1,3);


hold on
dem=plot(FMT.RCOU.TimeS,FMT.RCOU.C1,'.');

legend([dem],{'L AIL (+TE UP)'});

axis tight
grid on
box on

s5=subplot(5,1,5);


hold on
if isfield(FMT,'NKF1')
dem=plot(FMT.NKF1.TimeS,-FMT.NKF1.VD,'.');
else
  dem=plot(FMT.XKF1(1).TimeS,-FMT.XKF1(1).VD,'.');

  
end

accel=smooth(FMT.IMU(1).AccX,1,'lowess') -...
    (9.80665.*sind( interp1(FMT.ATT.TimeS,smooth(FMT.ATT.Pitch,1,'lowess'),FMT.IMU(1).TimeS)));

aplot=plot(FMT.IMU(1).TimeS,accel,'.');


legend([dem,aplot],{'Climb Rate m/s','X accel m/s/s'});

axis tight
grid on
box on



try
    linkaxes([s1,s2,s3,s4,s5],'x');
end
try
    xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3 s4 s5