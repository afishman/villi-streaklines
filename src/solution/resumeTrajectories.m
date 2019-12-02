matDir = '/Volumes/Oarfish/villi/SimData/mat/';
outDir = '/Volumes/Oarfish/villi/SimData/tolerance/1e-04/';

solution = Solution(matDir);
solution = loadTrajectories(solution, [outDir 'trajectories.csv']);

solution.xp = solution.trajectories.x(end);
solution.yp = solution.trajectories.y(end);

solution.settings.maxStep = 0.0001;

tStart = solution.trajectories.t(end);

resumeTrackParticles(solution, [tStart, 10], outDir);


%
animate(solution, 'render', outDir, 'xlim', xLim, 'ylim', yLim, 'speed', 1)