% Filter data based on pitch, roll, Acc
% figure
% Sync FMT, GND, AVT to common timeseries
% Set timeseries frequency
syncFreq = 50; 
% syncDatenum holds the datenums of each synced datapoint 
syncDatenum = min(INFO.flight.startTimeLOCAL):1/syncFreq/86400:max(INFO.flight.endTimeLOCAL);
% convert syncDatenum to TimeS for plotting
syncTimeS = (syncDatenum-INFO.pixhawkstart).*86400;
% Sync FMT, GND, AVT to common syncDatenum
[ SYNCFMT ] = fcnSYNC( FMT, syncDatenum, 'linear', 1 );
[ SYNCGND ] = fcnSYNC( GND, syncDatenum, 'linear', 2 );
[ SYNCAVT ] = fcnSYNC( AVT, syncDatenum, 'linear', 3 );


idxAuto = SYNCFMT.MODE.ModeNum == 10;

idxP = idxAuto;

idxPitch = abs(SYNCFMT.ATT.Pitch) < 3;%2.5;
idxRoll = abs(SYNCFMT.ATT.Roll) < 3;%2.5;

idxYawrate = rad2deg(abs(SYNCFMT.IMU.GyrZ)) < 1;%0.8;
idxRollrate = rad2deg(abs(SYNCFMT.IMU.GyrX)) < 1;%0.8;

idxAlt = rem(SYNCFMT.BARO.Alt,25) < 5 ...
    | rem(SYNCFMT.BARO.Alt,25) > 20;

idxS = idxP & idxPitch & idxRoll & idxYawrate & idxAlt;

% GPS X Y
mstruct = defaultm('mercator');
mstruct.origin = [43.9534 -79.3207 0]; % TEMAC LOCATION
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);
[X,Y] = mfwdtran(mstruct,SYNCFMT.GPS.Lat,SYNCFMT.GPS.Lng);



figure(1)
plot3(X(idxP),Y(idxP),SYNCFMT.BARO.Alt(idxP))
axis equal
% plot(syncTimeS(idxP), rad2deg(SYNCFMT.IMU.GyrZ(idxP)))
hold on
scatter3(X(idxS),Y(idxS),SYNCFMT.BARO.Alt(idxS));
% scatter(syncTimeS(idxS), SYNCFMT.ATT.Pitch(idxS) ,'.');
hold off

zticks(50:25:150)

grid on




%%
figure(10)
subplot(2,1,1)
% plot(syncTimeS, SYNCAVT.ADP.P_ALPHA,'k')
cla
xlabel('Time [s]')
ylabel('Alpha Diff. Pressure [Pa]');
hold on
plot(AVT.ADP.TimeS, smooth(AVT.ADP.P_ALPHA,50,'lowess'),'k')
hold off
grid on
grid minor
xlim([1200 1900])
ylim([-100 100])


subplot(2,1,2)
% plot(syncTimeS, SYNCAVT.ADP.P_ALPHA,'k')
cla
xlabel('Time [s]')
ylabel('Beta Diff. Pressure [Pa]');
hold on
plot(AVT.ADP.TimeS, smooth(AVT.ADP.P_BETA,50,'lowess'),'k')
hold off
grid on
grid minor
xlim([1200 1900])
ylim([-100 100])



figure(11)
scatter(SYNCFMT.ATT.Pitch(idxS), SYNCAVT.ADP.P_ALPHA(idxS), [], SYNCAVT.OUT.ARSP(idxS))




















