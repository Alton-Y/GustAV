function [  ] = Export( filename )
%PLOT_EXPORT Summary of this function goes here
%   Detailed explanation goes here
set(gcf,'PaperSize',[11 6.5],'PaperPosition',[0 0 11 6.5]);
set(gcf,'GraphicsSmoothing','off');
set(gcf,'Color',[1 1 1]);


print('plot_export_temp','-dpng','-r300')



end

