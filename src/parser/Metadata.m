function metadata = Metadata
% function metadata = Metadata(name)
% A metadata.mat should be specified within a simulation folder
% INPUT
%  name (optional). Create from known (either 'sim1', 'exp1')
%
% OUTPUT
%   metadata

% metadata = []
metadata = struct;

% Frame time
metadata.timeDelta = []; % constant timeDelta for each (takes priority over t)
metadata.t = [];  % array of solutiontimes for each file