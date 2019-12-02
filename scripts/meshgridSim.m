
% Edit this line
%matDir = 'path_to_matDir';

% Simulate a line of particles in the first intervillous space
name = mfilename;
outDir = sprintf('%s../render/%s/', matDir, name);

% Initialise solution
solution = Solution(matDir);

% Add a grid of particles
x = linspace(-3, 3, 20);
y = linspace(0, 2, 20);
[X, Y] = meshgrid(x, y);
solution = addParticles(solution, X, Y);

% Enable Looping
solution = enableLooping(solution);

% Plot initial condition
xLim = [-2, 2];
yLim = [0, 3];
% plotInitialCondition(solution, 'xlim', xLim, 'ylim', yLim)
drawnow;

% Integration Time Span (start at beginning of loop)
tSpan = [0, 100];

% Solve
solution = trackParticles(solution, tSpan, outDir);

% Render
fprintf('%i / %i particles destroyed', numDestroyedParticles(solution), solution.trajectories.numParticles)
animate(solution, 'render', outDir, 'xlim', xLim, 'ylim', yLim)
