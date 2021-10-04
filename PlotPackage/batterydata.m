function batterydata(INFO,FMT,GND,TEMPLOG,fig)
fig.Name = 'Battery Data';
clf(fig);


s1=subplot(4,1,1);
hold on
try
    v=plot(FMT.BAT.TimeS,FMT.BAT.Volt,'-k');
    vr = plot(FMT.BAT.TimeS,FMT.BAT.VoltR,'.k','MarkerSize',2);    
catch
    v=plot(FMT.CURR.TimeS,FMT.CURR.Volt,'-k');
end
t1a = s1.YLim(1):s1.YLim(2); %create left axis y-tick before axis tight

if isfield(FMT,'CUR2')==1 || isfield(FMT,'BAT2')==1
    yyaxis right
    try
        v2=plot(FMT.BAT2.TimeS,FMT.BAT2.Volt,'-b');
        vr2 = plot(FMT.BAT2.TimeS,FMT.BAT2.VoltR,'--b');
    catch
        v2=plot(FMT.CUR2.TimeS,FMT.CUR2.Volt,'-b');
    end
    t1b = s1.YLim(1):0.2:s1.YLim(2); %create right axis y-tick before axis tight
    axis tight

yyaxis left
% s1.YLim(1) = s1.YLim(1)-diff(s1.YLim)/1.5;
s1.YTick = t1a; %apply left axis y-tick
else
    axis tight
end

ylabel('Voltage [V]');

if isfield(FMT,'CUR2')==1  || isfield(FMT,'BAT2')==1
    yyaxis right
    s1.YLim(2) = s1.YLim(2)+diff(s1.YLim)/1.5; %adjust right axis
    s1.YTick = t1b; %apply right axis y-tick
    ylabel('Voltage [V]');
end
grid on
% grid minor
box on

if isfield(FMT,'CUR2')==1 || isfield(FMT,'BAT2')==1
    try
        legend([v,vr,v2,vr2],{'Main Volt','Main Rest. Volt','Second Volt','Second Rest. Volt'},'location','northwest');
    catch
        legend([v,v2],{'Main Volt','Second Volt'},'location','northwest');
    end
else
    try
        legend([v,vr],{'Main Volt','Main Rest. Volt,'},'location','northwest');
    catch
        
        legend([v],{'Main Volt'},'location','northwest');
    end
end
 yyaxis left
s2=subplot(4,1,2);
hold on
try
    a=plot(FMT.BAT.TimeS,FMT.BAT.Curr,'-k');
catch
a=plot(FMT.CURR.TimeS,FMT.CURR.Curr,'-k');
end
t2a = 0:10:s2.YLim(2); %create left axis y-tick before axis tight
s2.YLim(1) = s2.YLim(1)-diff(s2.YLim)/1.5;

if isfield(FMT,'CUR2')==1 ||  isfield(FMT,'BAT2')==1
yyaxis right
try
    a2=plot(FMT.BAT2.TimeS,FMT.BAT2.Curr,'-b');
catch
a2=plot(FMT.CUR2.TimeS,FMT.CUR2.Curr,'-b');
end
t2b = s2.YLim(1):0.5:s2.YLim(2); %create right axis y-tick before axis tight

axis tight

yyaxis left
s2.YLim(1) = s2.YLim(1);
s2.YTick = t2a; %apply left axis y-tick
else
    axis tight
end
ylabel('Current [A]');

if isfield(FMT,'CUR2')==1 || isfield(FMT,'BAT2')==1
yyaxis right
s2.YLim(2) = s2.YLim(2)+diff(s2.YLim)/1.5; %adjust right axis 
s2.YTick = t2b; %apply right axis y-tick
ylabel('Current [A]');
end
grid on
grid minor
box on
if isfield(FMT,'CUR2')==1 || isfield(FMT,'BAT2')==1
legend([a,a2],{'Main Curr','Second CUrr'},'location','northwest');
else
    legend([a],{'Main Curr'},'location','northwest');
end




s3=subplot(4,1,3);
hold on
try
  a=plot(FMT.BAT.TimeS,FMT.BAT.CurrTot,'-k'); 
catch
a=plot(FMT.CURR.TimeS,FMT.CURR.CurrTot,'-k');
end
s3.YLim(2) = s3.YLim(2)*1;
ylabel('mAh');
if isfield(FMT,'CUR2')==1 || isfield(FMT,'BAT2')==1
yyaxis right
try
 a2=plot(FMT.BAT2.TimeS,FMT.BAT2.CurrTot,'-b');
catch
a2=plot(FMT.CUR2.TimeS,FMT.CUR2.CurrTot,'-b');
end
legend([a,a2],{'Main Total Draw','Second Total Draw'},'location','northwest');
else
   legend([a],{'Main Total Draw'},'location','northwest'); 
end
ylabel('mAh');
axis tight
% s3.YLim(2) = s3.YLim(2)*2;
grid on
box on


s4=subplot(4,1,4);
% % hold on
% % try
% %     %altons format for dataflash:
% % for i= 1:size(FMT.BCL3.V1,1)
% % %     cell(i,1) = bi2de((bitget(FMT.BCL3.V1(i),8:-1:1)));
% % celld(i,1) = bi2de((bitget(FMT.BCL3.V1(i),1:1:8)))+220;
% % celld(i,2) = bi2de((bitget(FMT.BCL3.V1(i),9:1:16)))+220;    
% % end
% % figure
% % clf
% % hold on
% % plot(FMT.BCL3.TimeLOCAL-(4/24),celld(:,1),'.')
% % plot(FMT.BCL3.TimeLOCAL-(4/24),celld(:,2),'.')
% % 
% % 
% % 
% % 
% % 
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V2./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V3./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V4./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V5./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V6./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V1./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V2./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V3./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V4./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V5./1000,'.');
% % % plot(FMT.BCL3.TimeS,FMT.BCL3.V6./1000,'.');
% % grid on
% % box on
% % % ylim([2.7 4.3]);
% % legend('Cell 1','Cell 2');
% % catch
% % end
% % ylabel('Voltage [V]');
% % xlabel('Time [s]');
linkaxes([s1,s2,s3,s4],'x');
% try
% xlim([min(INFO.flight.startTimeS),max(INFO.flight.endTimeS)]);
% catch
%     axis tight
% end
clear s1 s2 s3

end