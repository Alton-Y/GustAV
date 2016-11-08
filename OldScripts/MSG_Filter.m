function [ MSG ] = MSG_Filter( INFO, keywords )
%MSG_FILTER Summary of this function goes here
%   Detailed explanation goes here
try
    % keywords = {'ARSP','BATT'};
    if sum(ismember(keywords,'ALL')) > 0
        MSG = INFO.MSG;
    else
        idx = ismember({INFO.MSG.Type},keywords);
        MSG = INFO.MSG(idx);
    end
    
    
    
    % SORT MSG BY TYPE
    Afields = fieldnames(MSG);
    Acell = struct2cell(MSG);
    sz = size(Acell) ;
    % Convert to a matrix
    Acell = reshape(Acell, sz(1), []);      % Px(MxN)
    % Make each field a column
    Acell = Acell';                         % (MxN)xP
    % Sort by first field "name"
    Acell = sortrows(Acell, 1);
    % Put back into original cell array format
    Acell = reshape(Acell', sz);
    % Convert to Struct
    MSG = cell2struct(Acell, Afields, 1);
catch
    MSG = [];
    
end

