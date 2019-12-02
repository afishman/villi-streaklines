function solution = trackParticles(solution, tSpan, outDir)
% Particles is an array where the first column is the x
% second column is the y
% Inputs: solution, tSpan (two element), filename (optional)
% Outputs: updated solution
% Check size of particles positions match
% Make directory is saving
if exist('outDir', 'var')
    outDir = addTrailingSlash(outDir);
    mkdir(outDir);
    save([outDir, 'solution.mat'], '-struct', 'solution');

    % Make an empty file
    fclose(fopen([outDir 'trajectories.csv'], 'w'));   
end

% Ensure no particles start inside a villi
distances = distanceToVilli(solution.tank, solution.xp, solution.yp);

if min(distances) <=0
    figure; hold on
    plotTank(solution.tank);
    plotParticles(solution.xp, solution.yp, solution.tank);

    error('Particles initial position inside villi')
end

% Simulate.
if exist('outDir', 'var')
    solution = resumeTrackParticles(solution, tSpan, outDir);
else
    solution = resumeTrackParticles(solution, tSpan);
end