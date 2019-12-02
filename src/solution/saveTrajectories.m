function saveTrajectories(solution, filename)

solution.trajectories.t = solution.trajectories.t(:);

csvdata = [solution.trajectories.t solution.trajectories.x solution.trajectories.y];

csvwrite(filename, csvdata) 
