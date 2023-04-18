function [] = Plot_Titleblock(INFO, PLOT)
close all
set(0,'DefaultFigureVisible','off')

an.title = PLOT.Title;
an.aircraft = INFO.Aircraft;

try
an.time = datestr(INFO.Time.LogStart,'HH:MM:SS');
an.flight = sprintf('%2.2d',INFO.Flight);
an.logDuration = char(INFO.Time.LogDuration);
an.flightDuration = char(INFO.Time.FlightDuration);
% an.note = PLOT.Note;

if PLOT.Segment == 0
    an.segment = 'ALL';
    PLOT.Segment = 1:max(INFO.Modes.Segment);
elseif length(PLOT.Segment) > 1
    an.segment = sprintf('%2.2d-%2.2d',PLOT.Segment(1),PLOT.Segment(end));
else
    an.segment = sprintf('%2.2d',PLOT.Segment(1));
end

catch
    an.time = '--:--:--';
    an.flight = '--';
    an.segment = '--';
    an.flightDuration = '--:--';
    an.logDuration = '--:--';
    an.segmentStart = '--:--';
    an.segmentEnd = '--:--';
    an.segmentDuration = '--:--';
    an.mode = '-/-';
end





% PLOT.Segment


if INFO.GNDTEST ~= 1

TrimIdx = sum((INFO.Modes.Segment==PLOT.Segment),2) & sum((INFO.Modes.isArmed==PLOT.isArmed & INFO.Modes.isFlying==PLOT.isFlying),2);

% ensure continuity of the plot
TrimStartIdx = find(TrimIdx==1, 1 );
TrimEndIdx = find(TrimIdx==1, 1, 'last' );


SegStartTimeS = INFO.Modes.ModeStartTimeUS(TrimStartIdx)./1e6;
SegEndTimeS = INFO.Modes.ModeEndTimeUS(TrimEndIdx)./1e6;

an.segmentStart = sprintf('%.1f',SegStartTimeS);
an.segmentEnd = sprintf('%.1f',SegEndTimeS);

segmentDuration = SegEndTimeS - SegStartTimeS;
an.segmentDuration = sprintf('%.2d:%2.2d',floor(segmentDuration/60),floor(rem(segmentDuration,60)));


% Flight Mode
if length(unique(PLOT.Segment))==1
    an.mode = INFO.Modes.ModeAbbr(TrimStartIdx);
else
    an.mode = '-/-';
end

end

% GND TEST
if INFO.GNDTEST == 1;
    an.date = INFO.Date;
    an.time = '--:--:--';
    an.mode = 'TEST';
else
    INFO.Date = datestr(INFO.Time.LogStart,'yyyy-mm-dd');
    an.date = INFO.Date;
end
    











DocWidth = 9;
C = 0.42;
DocWidth = DocWidth - C;
A = DocWidth/11*1.5;
B = DocWidth/11*1;

plot([1 1 10 10 1],[-0.25 1 1 -0.25 -0.25],'Color',[0 0 0]);
hold on
plot([1+A 10], [0.5 0.5], 'Color',[0 0 0]);
plot([1 10],[1.5 1.5],'Color',[1 1 1]);  % add top margin
% hline above note
plot([1+A 10], [0 0], 'Color',[0 0 0]);
axis image


G = [A B C];
% Vertical Lines
%
clear v
v(1,:) = [0 0 0].*G;
v(2,:) = [1 0 0].*G;                %logo
v(3,:) = [2 0 0].*G;                %Date/aircraft
v(4,:) = [2 0 1].*G;                %flight#
v(5,:) = [2 1 1].*G;                %time
v(6,:) = [2 2 1].*G;                %log duration
v(7,:) = [2 3 1].*G;                %flight duration
v(8,:) = [2 4 1].*G;                %segment #
v(9,:) = [2 5 1].*G;                %Seg start
v(10,:) =[2 6 1].*G;               %Seg end
v(11,:) =[2 7 1].*G;               %SEG duration
v(12,:) =[2 8 1].*G;               %flight mode
v = sum(v,2);
v = v+1; %add margin

boxTitle = {'','DATE','FLIGHT #','TIME','LOG DURATION','FLIGHT DURATION','SEGMENT #','SEGMENT START [s]','SEGMENT END [s]','SEGMENT DURATION','FLIGHT MODE'};
boxText = {'',an.date,an.flight,an.time,an.logDuration,an.flightDuration,an.segment,an.segmentStart,an.segmentEnd,an.segmentDuration,an.mode};



for n = 1:11
    if n == 1  %extra long vline
        plot([v(n+1) v(n+1)],[-0.25 1],'-k');
    elseif n == 2 % long vline
         plot([v(n+1) v(n+1)],[0 1],'-k');
    else
        % right vline
        plot([v(n+1) v(n+1)],[0.5 1],'-k');
    end
    
    % box title
    text(v(n)+0.05,1-0.075,boxTitle{n},'HorizontalAlignment','left','FontSize',7,'FontName','Agency FB','VerticalAlignment','cap');
    
    % box text
    text(v(n)+0.05,0.5+0.075,boxText{n},'HorizontalAlignment','left','FontSize',18,'FontName','Agency FB','VerticalAlignment','baseline');
end

% LOGO
vtexttop = 1-0.05-0.035;
vtextspace = 0.192*1.2;
vtextsize = 12.75*1.1;
text(1.06,vtexttop,'RYERSON','HorizontalAlignment','left','FontSize',vtextsize,'FontName','Agency FB','VerticalAlignment','cap');
text(1.06,vtexttop-vtextspace,'APPLIED','HorizontalAlignment','left','FontSize',vtextsize,'FontName','Agency FB','VerticalAlignment','cap');
text(1.06,vtexttop-2*vtextspace,'AERODYNAMICS','HorizontalAlignment','left','FontSize',vtextsize,'FontName','Agency FB','VerticalAlignment','cap');
text(1.06,vtexttop-3*vtextspace,'LABORATORY OF','HorizontalAlignment','left','FontSize',vtextsize,'FontName','Agency FB','VerticalAlignment','cap');
text(1.06,vtexttop-4*vtextspace,'FLIGHT','HorizontalAlignment','left','FontSize',vtextsize,'FontName','Agency FB','VerticalAlignment','cap');

% AIRCRAFT
text(v(2)+0.05,0.5-0.075,'AIRCRAFT','HorizontalAlignment','left','FontSize',7,'FontName','Agency FB','VerticalAlignment','cap');
text(v(2)+0.05,0.075,an.aircraft,'HorizontalAlignment','left','FontSize',18,'FontName','Agency FB','VerticalAlignment','baseline');

% TITLE
text(1.05+2*A,0.5-0.075,'TITLE','HorizontalAlignment','left','FontSize',7,'FontName','Agency FB','VerticalAlignment','cap');
text(1.05+2*A,0.075,an.title,'HorizontalAlignment','left','FontSize',18,'FontName','Agency FB','VerticalAlignment','baseline');


% NOTE
text(1.05+A,0-0.075,'NOTE','HorizontalAlignment','left','FontSize',7,'FontName','Agency FB','VerticalAlignment','cap');


try
    an.note = ' ';
    for n = 1:length(PLOT.MSG)
        an.note = sprintf('%s%i) %s     ',an.note,n,PLOT.MSG(n).Text);
    end
    text(1.05+A+.25,0-0.075,an.note,'HorizontalAlignment','left','FontSize',10,'FontName','Agency FB','VerticalAlignment','cap');
end







% text(1.05+A+0.25,0-0.075,an.note,'HorizontalAlignment','left','FontSize',10,'FontName','Agency FB','VerticalAlignment','cap');






set(gca,'Visible','off');
set(gcf,'PaperSize',[11 1],'PaperPosition',[0 0 11 2.25]);
set(gcf,'GraphicsSmoothing','off');
set(gcf,'Color',[1 1 1]);
print('plot_titleblock','-dpng','-r300')
%%
% clf
% set(gcf,'PaperSize',[11 1],'PaperPosition',[0 0 11 1]);
% plot([1 1 10 10 1],[0 0.5 0.5 0 0],'Color',[0 0 0]);
% set(gca,'Visible','off');
% print('plot_note','-dpng','-r300')

close all



set(0,'DefaultFigureVisible','on');



end