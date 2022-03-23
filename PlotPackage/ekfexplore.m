function ekfexplore(INFO,FMT,GND,fig)
fig.Name = 'EKF Explore';
clf(fig);

% look at ekf IPD (innovation position down) to look for altitude problems)
s1=subplot(4,1,1);
hold on
yyaxis left
if isfield(FMT,'NKF1')
att=plot(FMT.ATT.TimeS,FMT.ATT.Roll,'-k');
imu1=plot(FMT.NKF1.TimeS,FMT.NKF1.Roll,'--b');
imu2=plot(FMT.NKF6.TimeS,FMT.NKF6.Roll,'--r');
ax = gca;
ax.YColor = 'k';
ylabel('Angle (deg)');
yyaxis right
pi = plot(FMT.NKF4.TimeS,FMT.NKF4.PI,'.b');
ax = gca;
ax.YColor = 'b';
legend([att,imu1,imu2,pi],{'Roll ATT','Roll IMU1','Roll IMU2','EKF Instance'},'location','northwest');
ylabel('Instance');
axis tight
grid on
box on

else
    att=plot(FMT.ATT.TimeS,FMT.ATT.Roll,'-k');
imu1=plot(FMT.XKF1(1).TimeS,FMT.XKF1(1).Roll,'--b');
imu2=plot(FMT.XKF1(2).TimeS,FMT.XKF1(2).Roll,'--r');
ax = gca;
ax.YColor = 'k';
ylabel('Angle (deg)');
yyaxis right
pi = plot(FMT.XKF4(1).TimeS,FMT.XKF4(1).PI,'.b');
ax = gca;
ax.YColor = 'b';
legend([att,imu1,imu2,pi],{'Roll ATT','Roll IMU1','Roll IMU2','EKF Instance'},'location','northwest');
ylabel('Instance');
axis tight
grid on
box on

    
end



s2=subplot(4,1,2);
hold on

if isfield(FMT,'NKF1')
att=plot(FMT.ATT.TimeS,FMT.ATT.Pitch,'-k');
imu1=plot(FMT.NKF1.TimeS,FMT.NKF1.Pitch,'--b');
imu2=plot(FMT.NKF6.TimeS,FMT.NKF6.Pitch,'--r');
ylabel('Angle (deg)');
axis tight
grid on
box on
legend([att,imu1,imu2],{'Pitch ATT','Pitch IMU1','Pitch IMU2'},'location','northwest');
else
att=plot(FMT.ATT.TimeS,FMT.ATT.Pitch,'-k');
imu1=plot(FMT.XKF1(1).TimeS,FMT.XKF1(1).Pitch,'--b');
imu2=plot(FMT.XKF1(2).TimeS,FMT.XKF1(2).Pitch,'--r');
ylabel('Angle (deg)');
axis tight
grid on
box on
legend([att,imu1,imu2],{'Pitch ATT','Pitch IMU1','Pitch IMU2'},'location','northwest');

end
s3=subplot(4,1,3); %airspeed error (should be below 0.3. Above 1 data from pitot is ignored)
hold on
yyaxis left


if isfield(FMT,'NKF1') 
    
imu1=plot(FMT.NKF4.TimeS,FMT.NKF4.SVT,'--b');
imu2=plot(FMT.NKF9.TimeS,FMT.NKF9.SVT,'--r');
maxl = plot([min(FMT.NKF4.TimeS) max(FMT.NKF4.TimeS)],[1 1],'-r');
ax = gca;
ax.YColor = 'k';
ylabel('Error Ratio');
axis tight

yyaxis right
hold on
ivt= plot(FMT.NKF3.TimeS,FMT.NKF3.IVT,'-k');
ivt2= plot(FMT.NKF8.TimeS,FMT.NKF8.IVT,'--k');
ax = gca;
ax.YColor = 'k';
ylabel('Airspeed Innovation');


axis tight
grid on
box on
legend([imu1,imu2,maxl,ivt,ivt2],{'SVT IMU1','SVT IMU2','MAX ERROR','IVT IMU1','IVT IMU2'},'location','northwest');


else 
      
imu1=plot(FMT.XKF4(1).TimeS,FMT.XKF4(1).SVT,'--b');
imu2=plot(FMT.XKF4(2).TimeS,FMT.XKF4(2).SVT,'--r');
maxl = plot([min(FMT.XKF4(1).TimeS) max(FMT.XKF4(1).TimeS)],[1 1],'-r');
ax = gca;
ax.YColor = 'k';
ylabel('Error Ratio');
axis tight

yyaxis right
hold on
ivt= plot(FMT.XKF3(1).TimeS,FMT.XKF3(1).IVT,'-k');
ivt2= plot(FMT.XKF3(2).TimeS,FMT.XKF3(2).IVT,'--k');
ax = gca;
ax.YColor = 'k';
ylabel('Airspeed Innovation');


axis tight
grid on
box on
legend([imu1,imu2,maxl,ivt,ivt2],{'SVT IMU1','SVT IMU2','MAX ERROR','IVT IMU1','IVT IMU2'},'location','northwest');

 
    
    
    
    
end


if isfield(FMT,'NKF4')
s4=subplot(4,1,4); %mag error (should be below 0.3. Above 1 data from pitot is ignored)
hold on
imu1=plot(FMT.NKF4.TimeS,FMT.NKF4.SM,'--b');
imu2=plot(FMT.NKF9.TimeS,FMT.NKF9.SM,'--r');
maxl = plot([min(FMT.NKF4.TimeS) max(FMT.NKF4.TimeS)],[1 1],'-r');
ylabel('Error Ratio');
axis tight
grid on
box on
legend([imu1,imu2,maxl],{'SM IMU1','SM IMU2','MAX ERROR'},'location','northwest');
else
    s4=subplot(4,1,4); %mag error (should be below 0.3. Above 1 data from pitot is ignored)
hold on
imu1=plot(FMT.XKF4(1).TimeS,FMT.XKF4(1).SM,'--b');
imu2=plot(FMT.XKF4(2).TimeS,FMT.XKF4(2).SM,'--r');
maxl = plot([min(FMT.XKF4(1).TimeS) max(FMT.XKF4(1).TimeS)],[1 1],'-r');
ylabel('Error Ratio');
axis tight
grid on
box on
legend([imu1,imu2,maxl],{'SM IMU1','SM IMU2','MAX ERROR'},'location','northwest');
end

linkaxes([s1,s2,s3,s4],'x');
try
xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
catch
    axis tight
end
clear s1 s2 s3