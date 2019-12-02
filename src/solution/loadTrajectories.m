function solution = loadTrajectories(solution, filename)
% Get raw data
rawData = csvread(filename);

% Determine number of particles
numParticles = (size(rawData, 2)-1)/2;

% Separate into variables
t = rawData(:, 1);
x = rawData(:, 2:numParticles+1);
y = rawData(:, numParticles+2:end);

% Remove repeats
[~, idx] = unique(t);

% Form output struct
solution.trajectories = struct;
solution.trajectories.numParticles = numParticles;

solution.trajectories.t = t(idx);
solution.trajectories.x = rawData(idx, 2:numParticles+1);
solution.trajectories.y = rawData(idx, numParticles+2:end);