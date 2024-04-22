function [] = RPcontrolexploreROLL(INFO,FMT,GND,fig)
%plots info related to Roll/Pitch controllers

fig.Name = 'Roll/Pitch Controller Info 2';
clf(fig);

s1=subplot(4,1,1);
hold on
plot(FMT.PIDR.TimeS,FMT.PIDR.Act,'.')
plot(FMT.PIDR.TimeS,FMT.PIDR.Tar,'.')
ylabel('Rate')
legend('Act','Target','Location','best')
grid on

axis tight

% xlim([2936 2947])

% s2=subplot(4,1,2);
% hold on
% plot(FMT.PIDR.TimeS,FMT.PIDR.Err,'.')
% ylabel('Rate')
% legend('Err','Location','best')
% grid on
% 
% axis tight

% xlim([2936 2947])


s2=subplot(4,1,2);
hold on
plot(FMT.PIDR.TimeS,FMT.PIDR.FF,'.')
plot(FMT.PIDR.TimeS,FMT.PIDR.P,'.')
plot(FMT.PIDR.TimeS,FMT.PIDR.D,'.')
plot(FMT.PIDR.TimeS,FMT.PIDR.I,'.')
ylabel('Rate')
legend('FF','P','D','I','Location','best')
grid on

axis tight

% xlim([2936 2947])


scaled_value = (FMT.PIDR.FF + FMT.PIDR.P  + FMT.PIDR.I).*100;
scaled_value(scaled_value>4500)=4500;
scaled_value(scaled_value<-4500)=-4500;

pwmout = 1500+ ((scaled_value.*(2011-1500))./4500);
pwmout(scaled_value <0) = 1500-((-scaled_value(scaled_value<0)*(1500-998))./4500);
%  if (scaled_value > 0) {
%         return servo_trim + uint16_t( (scaled_value * (float)(servo_max - servo_trim)) / (float)high_out);
%     } else {
%         return servo_trim - uint16_t( (-scaled_value * (float)(servo_trim - servo_min)) / (float)high_out);
%     }
% xlim([2936 2947])


s3=subplot(4,1,3);
hold on

ylabel('PWM')

% plot(FMT.RCOU.TimeS,FMT.RCOU.C1,'.')
% plot(FMT.PIDR.TimeS,pwmout,'.' );

yyaxis right
ylabel('AIL')
hold on
plot(FMT.AETR.TimeS,FMT.AETR.Ail.*0.01,'.-r');
plot(FMT.PIDR.TimeS,FMT.PIDR.Act.*cell2mat(FMT.PARM(763,2)).*(interp1(FMT.AETR.TimeS,FMT.AETR.SS,FMT.PIDR.TimeS)),'.-b');
% legend('FF','P','D','Location','best')
grid on
% legend('PWM','Ail','FF perf')

axis tight

s4= subplot(4,1,4)
hold on
plot(FMT.PIDR.TimeS,FMT.PIDR.Dmod)
grid on
yyaxis right
plot(FMT.PIDR.TimeS,FMT.PIDR.SRate)
axis tight

linkaxes([s1,s2,s3,s4],'x');