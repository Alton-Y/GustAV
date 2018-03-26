function [] = rssidata(INFO,FMT,fig)
%plots channel data

fig.Name = 'Telem RSSI Data';
clf(fig);

%% RAW RSSI AND NOISE DATA
s1 = subplot(3,2,1);
hold on
rssip = plot(FMT.RAD.TimeS,FMT.RAD.RSSI);
remrssip = plot(FMT.RAD.TimeS,FMT.RAD.RemRSSI);
noisep = plot(FMT.RAD.TimeS,FMT.RAD.Noise);
remnoisep = plot(FMT.RAD.TimeS,FMT.RAD.RemNoise);

grid on
box on

ylabel('RSSI');
legend([rssip,remrssip,noisep,remnoisep],{'RSSI','RSSI Rem','Noise','Noise Rem'});
axis tight

%% DISTANCE TO ORIGIN / FIRST TAKEOFF
s2 = subplot(3,2,3);
hold on
try %try to use EKF origin
[actlen,az] = distance(mean(FMT.ORGN.Lat(FMT.ORGN.Lat>0)),mean(FMT.ORGN.Lng(FMT.ORGN.Lat>0)), FMT.AHR2.Lat,FMT.AHR2.Lng);
catch
    warning('No EKF Origin')
    flying = find(FMT.STAT.isFlying); %use location of first takeoff    
    [actlen,az] = distance(FMT.AHR2.Lat(flying(1)), FMT.AHR2.Lng(flying(1)), FMT.AHR2.Lat(FMT.AHR2.Lat~=0),FMT.AHR2.Lng(FMT.AHR2.Lat~=0));
    
end
dist = distdim(actlen,'deg','m','earth');

distp = plot(FMT.AHR2.TimeS(FMT.AHR2.Lat~=0),dist);
try
altp = plot(FMT.AHR2.TimeS,FMT.AHR2.Alt-mean(FMT.ORGN.Alt));
catch
    altp = plot(FMT.AHR2.TimeS(FMT.AHR2.Alt>0.1),FMT.AHR2.Alt(FMT.AHR2.Alt>0.1)-FMT.AHR2.Alt(flying(1)));
end
legend([distp,altp],{'Dist. to Origin','Alt'});
ylabel('m')
grid on
box on
axis tight


%% TX BUFFER AND ERRORS
s3 = subplot(3,2,5);
yyaxis left
hold on
txp=plot(FMT.RAD.TimeS,100-FMT.RAD.TxBuf); % FMT.RAD.TxBuf: percentage of buffer not used

grid on
box on
ax = gca;
ax.YColor = 'k';
yyaxis right
hold on
axis tight
errp=plot(FMT.RAD.TimeS,FMT.RAD.RxErrors);
fixed = plot(FMT.RAD.TimeS,FMT.RAD.Fixed);
legend([txp,errp,fixed],{'Tx Buff %','Rx Err','Fixed Err'});

%% SNR PLOT
% GPS X Y
mstruct = defaultm('mercator');
try 
    mstruct.origin = [mean(FMT.ORGN.Lat(FMT.ORGN.Lat>0)) mean(FMT.ORGN.Lng(FMT.ORGN.Lat>0)) 0]; % TEMAC LOCATION
catch
    mstruct.origin = [FMT.AHR2.Lat(flying(1))  FMT.AHR2.Lng(flying(1)) 0]; % TEMAC LOCATION

end
mstruct.geoid = referenceEllipsoid('wgs84','meters');
mstruct = defaultm(mstruct);
[X,Y] = mfwdtran(mstruct,FMT.AHR2.Lat(FMT.AHR2.Lat~=0),FMT.AHR2.Lng(FMT.AHR2.Lat~=0));

subplot(3,2,2);
colormap(flipud(jet(100)));
cdata = interp1(FMT.RAD.TimeS,(FMT.RAD.RSSI./FMT.RAD.Noise + FMT.RAD.RemRSSI./FMT.RAD.RemNoise)./2,FMT.AHR2.TimeS(FMT.AHR2.Lat~=0));
try
pxyz = scatter3(X,Y,FMT.AHR2.Alt-mean(FMT.ORGN.Alt),ones(size(X)),cdata);
catch
 pxyz = scatter3(X,Y,FMT.AHR2.Alt(FMT.AHR2.Lat~=0)-FMT.AHR2.Alt(flying(1)),ones(size(X)),cdata);   
end
axis equal
hcb=colorbar;
title(hcb,'Avg SNR')
caxis([1 3]);
setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera')
% try
%     xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
% catch
    axis tight
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
distremain = rangetimes.* interp1(FMT.AHR2.TimeS(FMT.AHR2.Lat~=0),dist,FMT.RAD.TimeS);

plot(FMT.RAD.TimeS,distremain);
ax = gca;
ax.YAxis.Exponent = 0;
legend('Dist','Rem Dist');
ylabel('m');
grid on
box on
axis tight
linkaxes([s1,s2,s3,s6],'x');
clear s1 s2 s3 s6 actlen az 