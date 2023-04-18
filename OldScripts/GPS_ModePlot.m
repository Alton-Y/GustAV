clf



% Check isfly
isfly = find(STAT(:,3)==1);
FltStart = STAT(min(isfly),2);
FltEnd = STAT(max(isfly),2);

%
ModeChange = MODE(:,[2,4]); %Copy mode
ModeChange(:,3) = [diff(MODE(:,4));NaN]; %find diff between mode change
ModeChange(:,4) = MODE(:,1);%mode start line index
ModeChange = ModeChange(ModeChange(:,3)~=0,:);
ModeChange(:,5) = [ModeChange(2:end,4)-1;inf];
ModeChange = ModeChange(ModeChange(:,1)>FltStart&ModeChange(:,1)<FltEnd,:);% Filter isfly
UniqueMode = unique(ModeChange(:,2));


mstruct = defaultm('mercator');
mstruct.origin = [GPS(1,8) GPS(1,9) 0];
mstruct = defaultm(mstruct);
%
for i = 1:length(UniqueMode);
    SingleMode = ModeChange(ModeChange(:,2)==UniqueMode(i),:); %filter each mode
    if isempty(SingleMode) ~= 1
        GPS_idx = zeros(length(GPS(:,1)),1);
        for j = 1:length(SingleMode(:,1))
            idx_start = SingleMode(j,4);
            idx_end = SingleMode(j,5);
            GPS_idx = or(GPS_idx,GPS(:,1)>=idx_start&GPS(:,1)<=idx_end);
        end
        
        [x,y] = mfwdtran(mstruct, GPS(GPS_idx,8),GPS(GPS_idx,9));
        
        hold on
        plot(x,y,'.');
        hold off
        
    end
end
clear x y
ModeString = {'Manual','CIRCLE','STABILIZE','TRAINING','ACRO','FBWA','FBWB','CRUISE','AUTOTUNE',' ','Auto','RTL','Loiter',' ',' ','Guided'};


figure(1)
axis equal
legend(ModeString(UniqueMode+1))















