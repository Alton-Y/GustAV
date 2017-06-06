function [ ModeIdx ] = fcnGETMODE( INFO, TimeS )
%FCNGETMODE Summary of this function goes here
%   Detailed explanation goes here

ModeIdx = zeros(size(TimeS));

for n = 1:length(INFO.segment.mode)
    if INFO.segment.mode(n) ~= 0
       idx = TimeS >= INFO.segment.startTimeS(n) & TimeS < INFO.segment.endTimeS(n);
       ModeIdx(idx) = repmat(INFO.segment.mode(n),sum(idx),1);
    end
end



end

