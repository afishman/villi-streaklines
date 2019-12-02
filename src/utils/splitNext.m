function [s1, s2]= splitNext(str, delimiter)
% function [s1 s2]= splitNext(str, delimiter)
% Cuts text at next delimiter, removing it from both return strings
%
% INPUT
%  str [] string to split
%  delimiter [] delimiter to split at
%
% OUTPUT
%  s1 [] before the split
%  s2 [] after the split
%

if str(1) == delimiter
    s1 = "";
    s2 = str(2:end);
    return
end

for i=2:length(str)
    if strcmp(str(i), delimiter)
        break;
    end
end

s1 = str(1:i-1);
s2 = str(i+1:end);