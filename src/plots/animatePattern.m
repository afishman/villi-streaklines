function animatePattern(tSpan, tank, pattern, framerate)
% function animatePattern(tSpan, tank, pattern, framerate)
% Animates a pattern to screen
%
% INPUT
%  tSpan [t0 tEnd] animation time span
%  tank [] Tank struct
%  pattern [] Pattern struct
%  framerate [] (optional, default:25) 

    if ~exist('framerate', 'var')
        framerate = 25;
    end
    
    if numel(tSpan)~=2
        error('tSpan must be a 2 element array that indicates start/end times')
    end
    
    % Animate
    for t = tSpan(1) : 1/framerate: tSpan(2)
        clf
        title(sprintf('t=%.1f', t));
        tank = updateTank(tank, pattern, t);
        plotTank(tank)
        
        pause(1/framerate);
    end
end