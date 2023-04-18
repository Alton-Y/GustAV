set(gcf, 'units','Inches');
pos = get(gcf,'Position');
set(gcf, 'Position', [pos(1),pos(2), 6,5]) %set size here in inches
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
cdir = pwd;
% set(gcf,'renderer','painters');
print('batt_discharge','-dpdf') %put a name here
cd (cdir);
