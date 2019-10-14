function magexplore(INFO,FMT,TLOG,fig)
fig.Name = 'Compass Data';
clf(fig);
% 
% Field	Description
% MagX, MagY. MagZ	Raw magnetic field values for x, y and z axis
% OfsX, OfsY, OfsZ	Raw magnetic offsets (will only change if COMPASS_LEARN parameter is 1)
% MOfsX, MOfsY, MOfsZ	Compassmot compensation for throttle or current

s1=subplot(5,1,1);
hold on
v=plot(FMT.MAG.TimeS,FMT.MAG.MagX,'.b');
m=plot(FMT.MAG2.TimeS,FMT.MAG2.MagX,'.k');
n=plot(FMT.MAG3.TimeS,FMT.MAG3.MagX,'.r');
axis tight
ylabel('MagX')
grid on
box on
axis tight
legend([v,m,n],{'MAG0','MAG1','MAG2'});

%%
s2=subplot(5,1,2);
hold on
v=plot(FMT.MAG.TimeS,FMT.MAG.MagY,'.b');
m=plot(FMT.MAG2.TimeS,FMT.MAG2.MagY,'.k');
n=plot(FMT.MAG3.TimeS,FMT.MAG3.MagY,'.r');
axis tight
ylabel('MagY')
grid on
box on
axis tight



s3=subplot(5,1,3);

hold on
v=plot(FMT.MAG.TimeS,FMT.MAG.MagZ,'.b');
m=plot(FMT.MAG2.TimeS,FMT.MAG2.MagZ,'.k');
n=plot(FMT.MAG3.TimeS,FMT.MAG3.MagZ,'.r');
axis tight
ylabel('MagZ')
grid on
box on
axis tight

s4=subplot(5,1,4);
hold on
v=plot(FMT.MAG.TimeS,FMT.MAG.Health,'.b');
m=plot(FMT.MAG2.TimeS,FMT.MAG2.Health,'.k');
n=plot(FMT.MAG3.TimeS,FMT.MAG3.Health,'.r');
axis tight
ylabel('Health')
grid on
box on
axis tight

s5=subplot(5,1,5); %mag error (should be below 0.3. Above 1 data from pitot is ignored)
hold on
imu1=plot(FMT.NKF4.TimeS,FMT.NKF4.SM,'--b');
imu2=plot(FMT.NKF9.TimeS,FMT.NKF9.SM,'--r');
maxl = plot([min(FMT.NKF4.TimeS) max(FMT.NKF4.TimeS)],[1 1],'-r');
ylabel('Error Ratio');
axis tight
grid on
box on


yyaxis right
hold on
inn=plot(FMT.NKF3.TimeS,FMT.NKF3.IYAW);
plot(FMT.MSG.TimeS,ones(length(FMT.MSG.TimeS),1),'.r');
text(FMT.MSG.TimeS,ones(length(FMT.MSG.TimeS),1),FMT.MSG.MessageStr,'Rotation',90)

% plot(FMT.NKF3.TimeS,FMT.NKF3.IMZ);
legend([imu1,imu2,maxl,inn],{'SM IMU1','SM IMU2','MAX ERROR','YAW INNOV'},'location','northwest');
linkaxes([s1,s2,s3,s4,s5],'x');

% try
%     xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
% catch
% %  
% end
clear s1 s2 s3

end