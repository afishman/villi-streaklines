function plotTrajectories(tank, trajectories, t, streaklines)
% streaklines: (default false)
hold on
markerSize = 10;
markerFaceColor = 'r';
markerEdgeColor = 'k';

if isempty(trajectories)
    return;
end

if ~exist('streaklines', 'var')
    streaklines = true;
end

% Plot streaklines
if ~exist('t', 'var')
    t = trajectories.t(end);
end

%tq = linspace(0, t, 100);
%xq = interp1(trajectories.t, trajectories.x, tq, 'nearest');
%yq = interp1(trajectories.t, trajectories.y, tq, 'nearest');

if false
    plot(xq, yq, ...
        'MarkerEdgeColor', markerEdgeColor,...
        'MarkerFaceColor', markerFaceColor,...
        'MarkerSize', markerSize ...
        )
end

idx = find(trajectories.t>t, 1);

% Plot particles
plotParticles(trajectories.x(idx,:)', trajectories.y(idx,:)', tank)
