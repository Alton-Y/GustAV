function [  ] = Plot_Create( INFO, PLOT, filename )
%PLOT_CREATE Summary of this function goes here
%   Detailed explanation goes here
folder = 'plots/';
% flightDate = datestr(INFO.Time.LogStart,'yyyy-mm-dd');
try
flightDate = INFO.Date;
catch
    flightDate = '';
end


if length(PLOT.Segment) == 1
    SegmentStr = sprintf('%i',PLOT.Segment);
elseif PLOT.Segment == 0
   
else
    SegmentStr = sprintf('%i-%i',PLOT.Segment(1),PLOT.Segment(end));
end

try
    fullfilename = sprintf('%s%s_Flight%i_%s_%s.png',folder,flightDate,INFO.Flight,SegmentStr,filename);
catch
    fullfilename = sprintf('%s%s_%s.png',folder,flightDate,filename);
end

set(gcf,'PaperSize',[11 6.5],'PaperPosition',[0 0 11 6.5]);
print('plot_export_temp','-dpng','-r300')

Plot_Titleblock(INFO, PLOT);


IM_titleblock = imread('plot_titleblock.png');
IM_main = imread('plot_export_temp.png');

% [A,B,C] = size(IM_titleblock);

IM_merge = [IM_titleblock;IM_main(50+26:end,:,:)];
% IM_merge = [IM_titleblock;IM_main];

% try
%     delete('plot_export_temp.png', 'plot_titleblock.png');
% end



imwrite(IM_merge,fullfilename);


end

