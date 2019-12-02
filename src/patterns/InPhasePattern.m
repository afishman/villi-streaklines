function pattern = InPhasePattern(frequency, amplitude, phase)
% In phase pattern f(t) 
if ~exist('phase')
    phase = 0;
end

ampRad = deg2rad(amplitude);
pattern = @(i,t) ampRad*sin(2*pi*frequency*t + phase) ;