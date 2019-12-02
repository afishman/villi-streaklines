function n = numDestroyedParticles(solution)
% function n = numDestroyedParticles(solution)
% How many particles that have been destroyed
%
% INPUT
%  solution [] ... 
%
% OUTPUT
%   [] ... 
%

    nanny = isnan(solution.trajectories.x) &  isnan(solution.trajectories.y);
    n = sum(any(nanny, 1));    
end