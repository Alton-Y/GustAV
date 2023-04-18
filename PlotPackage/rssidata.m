function [] = rssidata(INFO,FMT,TLOG,fig)
%plots channel data
%I think in the data flash log, local is the planes transceiver, remote is
%the ground unit. In mission planner, local is the ground unit, rem is the
%aircraft.
load('Field.mat');

fig.Name = 'Telem RSSI Data';
clf(fig);


% if we don't have a dataflash, we can try to plot the rssi data from a
% tlog. in a tlog, local is ground, rem is air unit. 
%% 
% localtime = datenum(TLOG.rssi_mavlink_radio_status_t(:,1)) + 1 + (4/24) + (16.5/60/60/24);
% tlog_radio_timeS =  (localtime - INFO.pixhawkstart).*86400;
% rssi_local2 = TLOG.rssi_mavlink_radio_status_t(:,2);
% noise_local2 = TLOG.noise_mavlink_radio_status_t(:,2);
% rssi_rem2 = TLOG.remrssi_mavlink_radio_status_t(:,2);
% noise_rem2 = TLOG.remnoise_mavlink_radio_status_t(:,2);

% hold on
% plot(tlog_radio_timeS,rssi_local,'k')
% plot(tlog_radio_timeS,noise_local,'k')
% plot(tlog_radio_timeS,rssi_rem,'k')
% plot(tlog_radio_timeS,noise_rem,'k')



%% RAW RSSI AND NOISE DATA
s1 = subplot(3,2,1);
hold on
% 
%%DATAFLASH:
cut = -1;
warning('We are hiding 0 rssi data!')
rssip = plot(FMT.RAD.TimeS(FMT.RAD.RSSI>cut),FMT.RAD.RSSI(FMT.RAD.RSSI>cut),'.b');
remrssip = plot(FMT.RAD.TimeS(FMT.RAD.RemRSSI>cut),FMT.RAD.RemRSSI(FMT.RAD.RemRSSI>cut),'.r');
noisep = plot(FMT.RAD.TimeS(FMT.RAD.Noise>cut),FMT.RAD.Noise(FMT.RAD.Noise>cut),'--b');
remnoisep = plot(FMT.RAD.TimeS(FMT.RAD.RemNoise>cut),FMT.RAD.RemNoise(FMT.RAD.RemNoise>cut),'--r');

%%TLOG:
% rssip = plot(tlog_radio_timeS,rssi_rem2,'-b');
% remrssip = plot(tlog_radio_timeS,rssi_local2,'-r');
% noisep = plot(tlog_radio_timeS,noise_rem2,'--b');
% remnoisep = plot(tlog_radio_timeS,noise_local2,'--r');

grid on
box on

ylabel('RSSI');
legend([rssip,remrssip,noisep,remnoisep],{'RSSI','RSSI Remote','Noise','Noise Remote'});
axis tight




%% DISTANCE TO ORIGIN / FIRST TAKEOFF
%note! AHR2 is backup position. Should use POS instead.
s2 = subplot(3,2,3);
yyaxis left
hold on
try %try to use EKF origin
[actlen,az] = distance(mean(FMT.ORGN.Lat(FMT.ORGN.Lat>0)),mean(FMT.ORGN.Lng(FMT.ORGN.Lat>0)), FMT.POS.Lat(FMT.POS.Lat~=0),FMT.POS.Lng(FMT.POS.Lat~=0));
catch
    warning('No EKF Origin')
    flying = find(FMT.STAT.isFlying); %use location of first takeoff    
    [actlen,az] = distance(FMT.POS.Lat(flying(1)), FMT.POS.Lng(flying(1)), FMT.POS.Lat(FMT.POS.Lat~=0),FMT.POS.Lng(FMT.POS.Lat~=0));
    
end
dist = distdim(actlen,'deg','m','earth');

distp = plot(FMT.POS.TimeS(FMT.POS.Lat~=0),dist);
try
altp = plot(FMT.POS.TimeS,FMT.POS.Alt-mean(FMT.ORGN.Alt));
catch
    altp = plot(FMT.POS.TimeS(FMT.POS.Alt>0.1),FMT.POS.Alt(FMT.POS.Alt>0.1)-FMT.POS.Alt(flying(1)));
end

ylabel('m')

grid on
box on
axis tight

yyaxis right
errp=plot(FMT.RAD.TimeS(FMT.RAD.RxErrors>0),FMT.RAD.RxErrors(FMT.RAD.RxErrors>0));
fixed = plot(FMT.RAD.TimeS,FMT.RAD.Fixed);
legend([distp,altp,errp,fixed],{'Dist. to Origin','Alt','Rx Err','Fixed Err'});

%% TX BUFFER AND ERRORS
s3 = subplot(3,2,5);
yyaxis left
hold on
txp=plot(FMT.RAD.TimeS,FMT.RAD.TxBuf); % FMT.RAD.TxBuf: number of bytes in radio ready to be sent

grid on
box on
ax = gca;
% ax.YColor = 'k';
yyaxis right
hold on

try
    lat = nan(length(TLOG.time_s_latency(:,2)),1);
    idx = (TLOG.time_s_latency(:,2)<100); %only plot where lat<100 sec
    lat(idx) = TLOG.time_s_latency(idx,2);
laten= plot(TLOG.time_s_latency(:,1),lat,'--.');
ylabel('s');
legend([txp,laten],{'Tx Buff %','Latency (MAVLINK)'});
catch
   legend([txp],{'Tx Buff %'}); 
end
axis tight



%% SNR PLOT
% GPS X Y
mstruct = defaultm('mercator');



try 
    mstruct.origin = [mean(FMT.ORGN.Lat(FMT.ORGN.Lat>0)) mean(FMT.ORGN.Lng(FMT.ORGN.Lat>0)) 0]; %LOCATION
catch
    mstruct.origin = [FMT.POS.Lat(flying(1))  FMT.POS.Lng(flying(1)) 0]; %LOCATION

end



mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);

% [X,Y] = mfwdtran(mstruct,FMT.POS.Lat(isnan(cdata)~=1),FMT.POS.Lng(isnan(cdata)~=1));

% TLOG:
% % [X,Y] = mfwdtran(mstruct,TLOG.lat_mavlink_global_position_int_t(:,2)./10000000,TLOG.lon_mavlink_global_position_int_t(:,2)./10000000);

s7=subplot(3,2,[2,4]);
% TLOG:
% % [C,ia,ic] =unique(tlog_radio_timeS);
% % cdata = interp1(C,(rssi_local2(ia)./noise_local2(ia) + rssi_rem2(ia)./noise_rem2(ia))./2,(TLOG.time_boot_ms_mavlink_global_position_int_t(:,2)./1000));

% cdata(isnan(cdata)) = 0.01; %replace nans with bad snr

% [RwyX,RwyY] = mfwdtran(mstruct,Field.Runway(:,2),Field.Runway(:,1));
% [LineX,LineY] = mfwdtran(mstruct,Field.Flightline(:,2),Field.Flightline(:,1));
% [RoadsX,RoadsY] = mfwdtran(mstruct,Field.Roads(:,2),Field.Roads(:,1));
% [TreesX,TreesY] = mfwdtran(mstruct,Field.Treeline(:,2),Field.Treeline(:,1));

try

    colormap(flipud(jet(100)));
    snr = (FMT.RAD.RemRSSI./FMT.RAD.RemNoise);
   snr(isnan(snr))=0;
cdata = interp1(FMT.RAD.TimeS,snr,FMT.POS.TimeS(FMT.POS.Lat~=0));
cdata(isnan(cdata))=0;
scatter3(FMT.POS.TimeS,-[FMT.POS(1).Lng],[FMT.POS(1).Lat],[],cdata'.');
view([-90,0])
axis tight
axis equal
% geoscatter(FMT.POS.Lat,FMT.POS.Lng,[],cdata)
h=colorbar 
caxis([1 3])
catch
pxyz = scatter3(X,Y,FMT.POS.Alt(isnan(cdata)~=1)-mean(mean(FMT.ORGN.Alt)),0.1./cdata(isnan(cdata)~=1)+3,cdata(isnan(cdata)~=1),'filled');

% TLOG:
% pxyz = scatter3(X,Y,TLOG.alt_mavlink_global_position_int_t(:,2)./1000-mean(mean(FMT.ORGN.Alt)),0.1./cdata+3,cdata,'filled');

 pxyz = scatter3(X,Y,FMT.POS.Alt(FMT.POS.Lat~=0)-FMT.POS.Alt(flying(1)),ones(size(X)),cdata,'filled');   
end

% axis equal
% pxlim = xlim;
% pylim = ylim;
% pzlim = zlim;

% Draw Runway
% hold on
% plot(RwyX,RwyY,'-k','Color',[0.2 0.2 0.2]);
% plot(LineX,LineY,'--r');
% plot(RoadsX,RoadsY,'--','Color',[0.5 0.5 0.5]);
% plot(TreesX,TreesY,'--','Color',[0.5 0.5 0.5]);
% hold off
% axis equal
% hcb=colorbar;
% title(hcb,'Avg SNR')
% caxis([1 3]);
% setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera')
% try
%     xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
% catch
%     axis tight
%     
%     xlim(pxlim);
%     ylim(pylim);
%     zlim(pzlim);
% end

%% DISTANCE REMAINING 
% see 
%http://ardupilot.org/copter/docs/common-3dr-radio-advanced-configuration-and-technical-information.html#diagnosing-range-problems
% and
%http://ardupilot.org/copter/docs/common-antenna-design.html#common-antenna-design-understanding-db-watts-and-dbm

s6=subplot(3,2,6);
% fademargin(:,1) = ((FMT.RAD.RSSI-FMT.RAD.Noise) )./2;
% fademargin(:,2) = ((FMT.RAD.RemRSSI-FMT.RAD.RemNoise) )./2;
% rangetimes = 2.^(fademargin./6);
% distremain = rangetimes.* interp1(FMT.POS.TimeS(FMT.POS.Lat~=0),dist,FMT.RAD.TimeS);
% hold on
% plot(FMT.RAD.TimeS,distremain(distremain(:,1)>0,1),'-b');
% plot(FMT.RAD.TimeS,distremain(distremain(:,2)>0,2),'-r');
% ax = gca;
% ax.YAxis.Exponent = 0;
% legend('Dist','Dist Remote');
% ylabel('m');
% grid on
% box on
% axis tight
linkaxes([s1,s2,s3,s6,s7],'x');
clear s1 s2 s3 s6 actlen az 