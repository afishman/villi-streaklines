close all
matDir = '/Volumes/Oarfish/villi/SimData/mat/';
solution = Solution(matDir);
solution = enableLooping(solution);

trajectoriesRootDir = '/Volumes/Oarfish/villi/SimData/tolerance/';
tolerances = [0, 1, 2, 3, 4];

figure
hold on
labels = {};
for i=1:length(tolerances)
    filename = sprintf('%s1e-0%i/trajectories.csv', trajectoriesRootDir, tolerances(i));
    solution = loadTrajectories(solution, filename);
    plot(solution.trajectories.t, solution.trajectories.y);
    labels{end+1} = sprintf('1e-0%i', tolerances(i));
end

legend(labels)

xlabel('Time (s)')
ylabel('y')