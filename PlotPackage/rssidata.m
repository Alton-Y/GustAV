function [] = rssidata(INFO,FMT,TLOG,fig)
%plots channel data
%I think in the data flash log, local is the planes transceiver, remote is
%the ground unit. In mission planner, local is the ground unit, rem is the
%aircraft.
load('Field.mat');

fig.Name = 'Telem RSSI Data';
% clf(fig);

%% RAW RSSI AND NOISE DATA
s1 = subplot(3,2,1);
hold on
rssip = plot(FMT.RAD.TimeS,FMT.RAD.RSSI,'-b');
remrssip = plot(FMT.RAD.TimeS,FMT.RAD.RemRSSI,'-r');
noisep = plot(FMT.RAD.TimeS,FMT.RAD.Noise,'--b');
remnoisep = plot(FMT.RAD.TimeS,FMT.RAD.RemNoise,'--r');

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
errp=plot(FMT.RAD.TimeS,FMT.RAD.RxErrors);
fixed = plot(FMT.RAD.TimeS,FMT.RAD.Fixed);
legend([distp,altp,errp,fixed],{'Dist. to Origin','Alt','Rx Err','Fixed Err'});

%% TX BUFFER AND ERRORS
s3 = subplot(3,2,5);
yyaxis left
hold on
txp=plot(FMT.RAD.TimeS,100-FMT.RAD.TxBuf); % FMT.RAD.TxBuf: percentage of buffer not used

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
    mstruct.origin = [mean(FMT.ORGN.Lat(FMT.ORGN.Lat>0)) mean(FMT.ORGN.Lng(FMT.ORGN.Lat>0)) 0]; % TEMAC LOCATION
catch
    mstruct.origin = [FMT.POS.Lat(flying(1))  FMT.POS.Lng(flying(1)) 0]; % TEMAC LOCATION

end
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);
[X,Y] = mfwdtran(mstruct,FMT.POS.Lat(FMT.POS.Lat~=0),FMT.POS.Lng(FMT.POS.Lat~=0));

subplot(3,2,[2,4]);
colormap(flipud(jet(100)));
cdata = interp1(FMT.RAD.TimeS,(FMT.RAD.RSSI./FMT.RAD.Noise + FMT.RAD.RemRSSI./FMT.RAD.RemNoise)./2,FMT.POS.TimeS(FMT.POS.Lat~=0));
cdata(isnan(cdata)) = 0.01; %replace nans with bad snr

[RwyX,RwyY] = mfwdtran(mstruct,Field.Runway(:,2),Field.Runway(:,1));
[LineX,LineY] = mfwdtran(mstruct,Field.Flightline(:,2),Field.Flightline(:,1));
[RoadsX,RoadsY] = mfwdtran(mstruct,Field.Roads(:,2),Field.Roads(:,1));
[TreesX,TreesY] = mfwdtran(mstruct,Field.Treeline(:,2),Field.Treeline(:,1));


try
pxyz = scatter3(X,Y,FMT.POS.Alt(FMT.POS.Lat~=0)-mean(mean(FMT.ORGN.Alt)),0.1./cdata+3,cdata,'filled');
catch
 pxyz = scatter3(X,Y,FMT.POS.Alt(FMT.POS.Lat~=0)-FMT.POS.Alt(flying(1)),ones(size(X)),cdata,'filled');   
end

axis equal
pxlim = xlim;
pylim = ylim;
pzlim = zlim;

% Draw Runway
hold on
plot(RwyX,RwyY,'-k','Color',[0.2 0.2 0.2]);
plot(LineX,LineY,'--r');
plot(RoadsX,RoadsY,'--','Color',[0.5 0.5 0.5]);
plot(TreesX,TreesY,'--','Color',[0.5 0.5 0.5]);
hold off
axis equal
hcb=colorbar;
title(hcb,'Avg SNR')
caxis([1 3]);
setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera')
% try
%     xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
% catch
    axis tight
    
    xlim(pxlim);
    ylim(pylim);
    zlim(pzlim);
% end

%% DISTANCE REMAINING 
% see 
%http://ardupilot.org/copter/docs/common-3dr-radio-advanced-configuration-and-technical-information.html#diagnosing-range-problems
% and
%http://ardupilot.org/copter/docs/common-antenna-design.html#common-antenna-design-understanding-db-watts-and-dbm

s6=subplot(3,2,6);
fademargin(:,1) = ((FMT.RAD.RSSI-FMT.RAD.Noise) )./2;
fademargin(:,2) = ((FMT.RAD.RemRSSI-FMT.RAD.RemNoise) )./2;
rangetimes = 2.^(fademargin./6);
distremain = rangetimes.* interp1(FMT.POS.TimeS(FMT.POS.Lat~=0),dist,FMT.RAD.TimeS);
hold on
plot(FMT.RAD.TimeS,distremain(:,1),'-b');
plot(FMT.RAD.TimeS,distremain(:,2),'-r');
ax = gca;
ax.YAxis.Exponent = 0;
legend('Dist','Dist Remote');
ylabel('m');
grid on
box on
axis tight
linkaxes([s1,s2,s3,s6],'x');
clear s1 s2 s3 s6 actlen az 