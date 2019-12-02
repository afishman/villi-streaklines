% An initial seed of particles arranged in a T formation

%matDir = 'path_to_matDir';

% Simulate a line of particles in the first intervillous space
name = mfilename;
outDir = sprintf('./render/%s/', name);

% Initialise solution
disp('loading solution')
solution = Solution(matDir);

disp('solution loaded')
% Add Intervillous Particles
yp = 0.5:0.1:1.5;
xp = 0.5*ones(1, length(yp));
solution = addParticles(solution, xp, yp);

% Add Supervillous Particles
xp = -0.2:0.1:1.2;
yp = 1.5*ones(1, length(xp));
solution = addParticles(solution, xp, yp);



% Enable Looping
solution = enableLooping(solution);

% Plot initial condition
xLim = [-1, 2];
yLim = [0, 3];
%plotInitialCondition(solution, 'xlim', xLim, 'ylim', yLim)
%drawnow;

% Integration Time Span (start at beginning of loop)
tSpan = [0, 10];

% Solve
disp('tracking...')
solution = trackParticles(solution, tSpan, outDir);

% Render
fprintf('%i / %i particles destroyed', numDestroyedParticles(solution), solution.trajectories.numParticles)
animate(solution, 'render', outDir, 'xlim', xLim, 'ylim', yLim);

