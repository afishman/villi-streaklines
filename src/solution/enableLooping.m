function solution = enableLooping(solution)
% function solution = enableLooping(solution)
% Sets up looping for a solution with respect to its pattern
% Loop start/end to 0 phase and fits as many cycles as possible
% Requires a pattern with frequency and phase
%
% INPUT
%  solution [] Solution struct 
%
% OUTPUT
%   [] Updated Solution


% Housekeeping
checkFields(solution.metadata, 'pattern');
checkFields(solution.metadata.pattern, {'frequency', 'phase'});

tMax = solution.interpolator.tMax;
phase = solution.metadata.pattern.phase;
freq = solution.metadata.pattern.frequency;

% Determine loop start/end
loopStart = (2*pi - phase)/(2*pi*freq);
loopEnd = loopStart + floor((tMax - loopStart)/freq);

% Set loop
solution.interpolator.loopSpan = [loopStart loopEnd];
solution.interpolator.looping = true;

% Set Pattern to 0 phase
zeroPhaseMetadata = solution.metadata;
zeroPhaseMetadata.pattern.phase = 0;
solution.pattern = Pattern(zeroPhaseMetadata);