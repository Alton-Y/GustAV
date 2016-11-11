function [FMT] =  FMT_Load(filename)


load(filename);

varList = Seen;


for i = 1:length(varList)
    %     if exist(varList{i}) == 1 % check if label exists but main array doesn't
    try
        % eg: label = AHR2_label
        eval(sprintf('label = %s_label;',varList{i}));
        
        for j = 1:length(label)
            % eg: FMT.AHR2.LineNo = AHR2(:,1)
            eval(sprintf('FMT.%s.%s = %s(:,%i);',varList{i},label{j},varList{i},j));
        end
        
        
%     catch
%         try
%             % eg: FMT.PARM = PARM
%             eval(sprintf('FMT.%s = %s;',varList{i},varList{i}));
%         catch
%             eval(sprintf('disp(%s);',varList{i}));
%         end
%     end
    % eg: clear AHR2_label
    eval(sprintf('clear %s;',varList{i}));
    eval(sprintf('clear %s_label;',varList{i}));

end

FMT.Seen = Seen;
FMT.PARM = PARM;

end