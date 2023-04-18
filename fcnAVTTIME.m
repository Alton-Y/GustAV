function [ TimeAddH ] = fcnAVTTIME( TimeH, dataFreq )
%FCNAVTTIME Summary of this function goes here
%   Detailed explanation goes here
    [~,~,C] = unique(TimeH);
    [a,~]=hist(C,unique(C));
    a = a';
    TimeAddH = [];
    
    for n = 1:length(a)
        TimeAddH = [TimeAddH;((0:a(n)-1)')./dataFreq./3600];
    end

end

