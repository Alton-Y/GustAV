function [ INFO ] = MSG_Add( INFO, Type, Text )
%INFO_ADDMESSAGE Summary of this function goes here
%   Detailed explanation goes here
n = length(INFO.MSG)+1;

INFO.MSG(n).Type = Type;
INFO.MSG(n).Text = Text;


end

