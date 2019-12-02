function arr = regexSort(arr, pattern)
% function arr = regexSort(arr, pattern)
% Performs sort using regex using the first parsed variable as the
% comparison
%
% INPUT
%  arr [] cell array of strings 
%  pattern [] regex pattern string 
%
% OUTPUT
%   [] sorted strings
%

% Sort files
tokens =  regexp(arr,  pattern, 'tokens', 'once');
empties = cellfun(@(x) isempty(x), tokens);

tokens(empties) = [];
arr(empties) = [];

indices = cellfun(@(x) str2double(x{1}), tokens);
[~, reindex] = sort(indices);
arr = arr(reindex);