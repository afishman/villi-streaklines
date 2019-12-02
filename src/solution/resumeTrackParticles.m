function solution = resumeTrackParticles(solution, tSpan, outDir)
% function solution = resumeTrackParticles(solution, tSpan, filename)
% Resumes a solution
%
% INPUT
%  solution [] Solution struct 
%  tSpan [t0, tEnd] or [tEnd] time span to solve for 
%  filename (optional) file to save solution data to
%
% OUTPUT
%   [] solution containing streaklines

saveOutput = exist('outDir', 'var');
if saveOutput
    outDir = addTrailingSlash(outDir);
    trajectoriesFilename = [outDir 'trajectories.csv'];
end


% Initial time set by previous end point
if numel(tSpan) == 1 
    tSpan = [solution.trajectories.t(end) tSpan];
end

% Initial condition
if isempty(solution.trajectories)
    xp = solution.xp(:);
    yp = solution.yp(:);

else
    xp = solution.trajectories(end).x(end,:);
    yp = solution.trajectories(end).y(end,:);   
end


% Simulate. Integration halts when a particle crashes into a villi. This
% loop restarts until tSpan has been spanned
count = 0;
solution.trajectories = Trajectories;
while tSpan(1)~=tSpan(2)
    count = count+1;
    
    % Time span for the next solver call
    T = [tSpan(1), min([tSpan(2) tSpan(1)+solution.settings.saveTime])];
    
    % Initial Condition
    y0 = [
        xp;
        yp;
    ];

    % Solver options
    solution.odeset = odeset(...
        'RelTol', solution.settings.relTol, ...
        'AbsTol', solution.settings.absTol, ...
        'MaxStep', solution.settings.maxStep, ...
        'Events', @(t,y)eventsFun(t, y, solution.tank, solution.pattern) ...
    );

    % Simulate
    tic;
    sol = ode45(@(t,y) odeFun(t, y, solution.interpolator), T, y0, solution.odeset);
    
    % Process events
    [xp, yp] = processEvents(sol);
    
    numParticles = length(solution.xp);
    t = sol.x';
    x = sol.y(1:numParticles, :)';
    y = sol.y(1+numParticles:end, :)';
    
    % Trim data to avoid repeat of IC
    if count~=1
        t = t(2:end);
        x = x(2:end, :);
        y = y(2:end, :);        
    end
    
    % Append to struct
    solution.numParticles = numParticles;
    solution.trajectories.t = [solution.trajectories.t; t];
    solution.trajectories.x = [solution.trajectories.x; x];
    solution.trajectories.y = [solution.trajectories.y; y];
    
    % Write to file
    if saveOutput
        dlmwrite(trajectoriesFilename, [t x y], '-append');
    end
    
    tSpan = [sol.x(end), tSpan(2)];   
end
