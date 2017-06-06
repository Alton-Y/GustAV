function [  ] = Plot_Format( ax )
%PLOT_FORMAT Summary of this function goes here
%   Detailed explanation goes here

ax.FontName = 'Agency FB';
ax.FontSize = 10;
ax.TickDir = 'out';
ax.Box = 'off';
ax.ColorOrder = [.5,.5,.5;0,0,0];
ax.ColorOrderIndex = 2;
ax.LineStyleOrder = {'-','--','-.'};
ax.LineStyleOrderIndex = 1;
ax.TickLength = [0.0063;0.0125];
ax.XGrid = 'On';
ax.XMinorGrid = 'On';
ax.YGrid = 'On';
ax.YMinorGrid = 'On';
ax.NextPlot = 'add';
ax.FontSmoothing = 'off';
ax.LineWidth = 0.5;

set(ax,'DefaultLineLineWidth',1)
end

