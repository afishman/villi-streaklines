function plotSeedsIc(seedFilepath, matDir)

% Load seed Data
text = fileread(seedFilepath);
seedData = jsondecode(text);

solution = Solution(matDir);

solution = setSeeds(solution, seedData);

% Frames per oscillation / period
plotInitialCondition(solution);