function trajectories = Trajectories(sols)
% Sols: cell array of solutions

% Form trajectories, given an ode solution
trajectories = struct;
trajectories.t = [];
trajectories.x = [];
trajectories.y = [];

if ~exist('sols')
    trajectories.numParticles = 0;
    return
end



for i = 1:length(sols)
    sol = sols{i};

    % Determine number of particles
    s = size(sol.y);
    
    if mod(s(1), 2)
        error('Uneven ode variable size')
    end
    numParticles = s(1)/2;
    
    % Form trajectory structure
    trajectories.numParticles = numParticles;
    t = sol.x';
    x = sol.y(1:numParticles, :)';
    y = sol.y(1+numParticles:end, :)';   
    
    % Trim first timestep to avoid repetition off
    if i>1
       	if isempty(t) || length(t)==1
            continue
        end
        
        t = t(2:end, :);
        x = x(2:end, :);
        y = y(2:end, :);
    end
    
    % Append
    trajectories.numParticles = numParticles;
    trajectories.t = [trajectories.t; t];
    trajectories.x = [trajectories.x; x];
    trajectories.y = [trajectories.y; y];
end


