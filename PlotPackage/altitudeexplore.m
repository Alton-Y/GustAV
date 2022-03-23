function [] = altitudeexplore(INFO,FMT,fig)
%plots different altitude sources and the EKF prediction


fig.Name = 'Altitude Data';
clf(fig);

a(1) = subplot(1,3,1);
hold on
plot(FMT.BARO(1).TimeS,FMT.BARO(1).Alt)
if isfield(FMT,'NKF1')
plot(FMT.NKF1.TimeS,-FMT.NKF1.PD)
else 
   plot(FMT.XKF1(1).TimeS,-FMT.XKF1(1).PD)
 
end
plot(FMT.POS.TimeS,FMT.POS.RelHomeAlt,'--')
plot(FMT.POS.TimeS,FMT.POS.RelOriginAlt,'--')
try
    plot(FMT.TECS.TimeS,FMT.TECS.h)
    legend('Baro','EKF','RelHomeAlt','RelOriginAlt','TECS')
catch
     legend('Baro','EKF','RelHomeAlt','RelOriginAlt')
end
grid on
box on


a(2) = subplot(1,3,2)
hold on
plot(FMT.GPS(1).TimeS,FMT.GPS(1).Alt)
plot(FMT.POS.TimeS,FMT.POS.Alt)
plot(FMT.AHR2.TimeS,FMT.AHR2.Alt)

plot(FMT.ORGN.TimeS(FMT.ORGN.Type==0),FMT.ORGN.Alt(FMT.ORGN.Type==0),'bd')
plot(FMT.ORGN.TimeS(FMT.ORGN.Type==1),FMT.ORGN.Alt(FMT.ORGN.Type==1),'rd')
grid on
box on
legend('GPS','POS','AHR2','EKF ORIGIN','AHRS HOME')

a(3) = subplot(1,3,3)
hold on

if isfield(FMT,'NKF4')
plot(FMT.NKF4.TimeS,FMT.NKF4.FS,'.') %faults
plot(FMT.NKF4.TimeS,FMT.NKF4.TS,'.') %timeout
plot(FMT.NKF4.TimeS,FMT.NKF4.SS,'.') %solution status
plot(FMT.NKF4.TimeS,FMT.NKF4.GPS,'.') %gps status

else
  plot(FMT.XKF4(1).TimeS,FMT.XKF4(1).FS,'.') %faults
plot(FMT.XKF4(1).TimeS,FMT.XKF4(1).TS,'.') %timeout
plot(FMT.XKF4(1).TimeS,FMT.XKF4(1).SS,'.') %solution status
plot(FMT.XKF4(1).TimeS,FMT.XKF4(1).GPS,'.') %gps status  
    
end
legend('Fault','Timeout','Solution','GPS');
grid on
box on

linkaxes(a,'x')


% faults
%  0 = quaternions are NaN
%  1 = velocities are NaN
%  2 = badly conditioned X magnetometer fusion
%  3 = badly conditioned Y magnetometer fusion
%  5 = badly conditioned Z magnetometer fusion
%  6 = badly conditioned airspeed fusion
%  7 = badly conditioned synthetic sideslip fusion
%  7 = filter is not initialised

% return filter timeout status as a bitmasked integer
%  0 = position measurement timeout
%  1 = velocity measurement timeout
%  2 = height measurement timeout
%  3 = magnetometer measurement timeout
%  4 = true airspeed measurement timeout
%  5 = unassigned
%  6 = unassigned
%  7 = unassigned

% EKF status. Is this the same as the ekf status in MP? only up to
% pred_horiz_pos_abs is sent to MP
% 0    filterStatus.flags.attitude = !stateStruct.quat.is_nan() && filterHealthy;   // attitude valid (we need a better check)
% 1    filterStatus.flags.horiz_vel = someHorizRefData && filterHealthy;      // horizontal velocity estimate valid
% 2    filterStatus.flags.vert_vel = someVertRefData && filterHealthy;        // vertical velocity estimate valid
% 3    filterStatus.flags.horiz_pos_rel = ((doingFlowNav && gndOffsetValid) || doingWindRelNav || doingNormalGpsNav) && filterHealthy;   // relative horizontal position estimate valid
% 4    filterStatus.flags.horiz_pos_abs = doingNormalGpsNav && filterHealthy; // absolute horizontal position estimate valid
% 5    filterStatus.flags.vert_pos = !hgtTimeout && filterHealthy && !hgtNotAccurate; // vertical position estimate valid
% 6    filterStatus.flags.terrain_alt = gndOffsetValid && filterHealthy;		// terrain height estimate valid
% 7    filterStatus.flags.const_pos_mode = (PV_AidingMode == AID_NONE) && filterHealthy;     // constant position mode
% 8    filterStatus.flags.pred_horiz_pos_rel = ((optFlowNavPossible || gpsNavPossible) && filterHealthy) || filterStatus.flags.horiz_pos_rel; // we should be able to estimate a relative position when we enter flight mode
% 9    filterStatus.flags.pred_horiz_pos_abs = (gpsNavPossible && filterHealthy) || filterStatus.flags.horiz_pos_abs; // we should be able to estimate an absolute position when we enter flight mode
% 10    filterStatus.flags.takeoff_detected = takeOffDetected; // takeoff for optical flow navigation has been detected
% 11    filterStatus.flags.takeoff = expectGndEffectTakeoff; // The EKF has been told to expect takeoff and is in a ground effect mitigation mode
% 12    filterStatus.flags.touchdown = expectGndEffectTouchdown; // The EKF has been told to detect touchdown and is in a ground effect mitigation mode
% 13    filterStatus.flags.using_gps = ((imuSampleTime_ms - lastPosPassTime_ms) < 4000) && (PV_AidingMode == AID_ABSOLUTE);
% 14    filterStatus.flags.gps_glitching = !gpsAccuracyGood && (PV_AidingMode == AID_ABSOLUTE) && !extNavUsedForPos; // GPS glitching is affecting navigation accuracy
% 15    filterStatus.flags.gps_quality_good = gpsGoodToAlign;

% // set individual flags
%     0 faults.flags.bad_sAcc           = gpsCheckStatus.bad_sAcc; // reported speed accuracy is insufficient
%     1 faults.flags.bad_hAcc           = gpsCheckStatus.bad_hAcc; // reported horizontal position accuracy is insufficient
%     2 faults.flags.bad_vAcc           = gpsCheckStatus.bad_vAcc; // reported vertical position accuracy is insufficient
%     3 faults.flags.bad_yaw            = gpsCheckStatus.bad_yaw; // EKF heading accuracy is too large for GPS use
%     4 faults.flags.bad_sats           = gpsCheckStatus.bad_sats; // reported number of satellites is insufficient
%     5 faults.flags.bad_horiz_drift    = gpsCheckStatus.bad_horiz_drift; // GPS horizontal drift is too large to start using GPS (check assumes vehicle is static)
%     6 faults.flags.bad_hdop           = gpsCheckStatus.bad_hdop; // reported HDoP is too large to start using GPS
%     7 faults.flags.bad_vert_vel       = gpsCheckStatus.bad_vert_vel; // GPS vertical speed is too large to start using GPS (check assumes vehicle is static)
%     8 faults.flags.bad_fix            = gpsCheckStatus.bad_fix; // The GPS cannot provide the 3D fix required
%     9 faults.flags.bad_horiz_vel      = gpsCheckStatus.bad_horiz_vel; // The GPS horizontal speed is excessive (check assumes the vehicle is static)