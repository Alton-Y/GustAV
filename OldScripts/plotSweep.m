% LOG OUTPUT SWEEP
clear
clc
listing = dir('logs/GustAV');
%%


for n = length({listing.name})-1:length({listing.name})-1
    
    
    % n = 1;
    % listing(n).name = '2016-05-07_Flight1.mat';
    
    %     try
    clear FMT INFO PLOT
    INFO.Aircraft = 'GustAV';
    %         INFO.Aircraft = 'GustAV';
    PLOT.Segment = 0;
    PLOT.isArmed = 1;
    PLOT.isFlying = 1;
    listing(n).name
    C = strsplit(listing(n).name,'_');
    B = strsplit(listing(n).name,'Flight');
    INFO.Date = C{1};
    INFO.Flight = str2double(B{2}(1:end-4));
    
    FMT = FMT_Load(listing(n).name);
    
    
    INFO = FMT_GetInfo( INFO,FMT );
    
    try
        Plot_FlightOverview(INFO,PLOT,FMT);
    end
    try
        Plot_AutotuneAnalysis(INFO,PLOT,FMT);
    end
    try
        Plot_WindEstimation(INFO,PLOT,FMT);
    end
    try
        Plot_BatteryMonitor(INFO,PLOT,FMT,1);
    end
    try
        Plot_BatteryMonitor(INFO,PLOT,FMT,2);
    end  
    
    %     end
    
    %     clear
end