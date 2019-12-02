function pattern = Pattern(metadata)
% function pattern = Pattern(metadata)
% Constuct a pattern from metadata. Used to update tank state
%
% INPUT
%  metadata [] metadata struct that contains a pattern struct. fields ust
%  include a 'type' field to indicate pattern type (eg inphase) and the
%  variables needed to construct that pattern
%  If no data is supplied a default 0 angle pattern is returned
%
% OUTPUT
%   [] function handle with form @(i,t) where i is villi index and t
% is the current time
%

% Default pattern
if ~exist('metadata', 'var')
    pattern = @(i,x) 0;
    return
end

% Check that data exists
checkFields(metadata, 'pattern')
checkFields(metadata.pattern, 'type')

% Determine variables required and pattern constructor
varNames = {};
fun = [];
switch(lower(metadata.pattern.type))
    case 'inphase'
        varNames = {'frequency', 'amplitude', 'phase'};
        fun = @InPhasePattern;
        
    otherwise
        error('Unknown pattern %s', metadata.pattern.type)
        
end

% Extract variables
checkFields(metadata.pattern, varNames);
vars = cellfun(@(f) metadata.pattern.(f), varNames, 'UniformOutput', false);

% Construct pattern
pattern = fun(vars{:});
