function [ SYNCFMT ] = fcnSYNC( FMT, plotDatenumArray, interpMethod, mode )
%FCNSYNCFMT Summary of this function goes here
%   Detailed explanation goes here
% Mode == 1: Pixhawk - FMT Data
% Mode == 2: Ground Station - GND Data
% Mode == 3: Aventech - AVT Data

% if mode == 1 || mode == 2 || mode == 3
    fn = fieldnames(FMT);
    
    if mode == 1
        fn = sort(fn);
        % Handle .Seen and .PARM differently as they are not timebased parameters
        SYNCFMT.Seen = FMT.Seen;
        SYNCFMT.PARM = FMT.PARM;
        
        try
        SYNCFMT.STRT = FMT.STRT;   %strt is old and not used anymore     
        catch
        end
        SYNCFMT.ORGN = FMT.ORGN;
    end
    
    for n = 1:length(fn)
        try

            fn2 = fieldnames(FMT.(fn{n}));
            for j = 1:length(fn2)

                
                
                if isempty(strfind(fn2{j},'Time')) == 1
                    for kk = 1:size(FMT.(fn{n}),2)
                        try
                            SYNCFMT.(fn{n})(kk).(fn2{j}) = [interp1(FMT.(fn{n})(kk).TimeLOCAL,FMT.(fn{n})(kk).(fn2{j}),plotDatenumArray,interpMethod,NaN)]';
                        end
                    end
                    if strcmp(fn{n},'MODE') == 1
                        try
                            SYNCFMT.(fn{n}).(fn2{j}) = [interp1(FMT.(fn{n}).TimeLOCAL,FMT.(fn{n}).(fn2{j}),plotDatenumArray,'previous','extrap')]';
                        end
                    end
                    
                end
                
            end
        catch
            %         n
%                     fn{n}
        end
    end
    
    
% elseif mode == 2
%     fn2 = fieldnames(FMT);
%     for j = 1:length(fn2)
%         if isempty(strfind(fn2{j},'Time')) == 1
%             SYNCFMT.(fn2{j}) = [interp1(FMT.TimeLOCAL,FMT.(fn2{j}),plotDatenumArray,interpMethod,NaN)]';
%         end
%     end
% end



end

