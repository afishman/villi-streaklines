function solution = Solution(matDir)
% function solution = Solution(matDir)
% Initialises a streakline solution. Contains data needed to
% calculate streaklines. Including Pattern, Tank, Interpolator, Integrator
% settings etc....
%
% INPUT
%  matDir [] Reads metadata.mat from matDir and uses that to form solution
%
% OUTPUT
%   [] Solution struct used a starting point when forming solution


%% Default empty solution
solution = struct;

% Trajectories of tracked particles
solution.trajectories = [];

% Initial poistions of the particles
solution.xp = [];
solution.yp = [];

% Solutions from an ode solver (eg ode45)
solution.sols = cell(0,1); 

% FrameInterpolator used to interpolate a dataset
solution.interpolator = [];  

% An array of villi
solution.tank = Tank;

% Function handle that returns villi angle @(i,t) 
solution.pattern = Pattern;

% General settings
solution.settings = Settings; 

% odeset given into solver (set by trackParticles)
solution.odeset = []; 

% Metadata included in the directory of mat files
solution.metadata = struct;

if ~exist('matDir', 'var')
    return;
end

%% Load from directory

% Load metadata
% Hacky and halfway    
simJsonPath = [matDir, 'sim.json']; 
if exist(simJsonPath, 'file')
    solution.metadata = struct;
    
    text = fileread(simJsonPath);
    json = jsondecode(text);
    solution.timeDelta = json.step_size*json.delta;
        
elseif exist([matDir, 'metadata.mat'], 'file')
    solution.metadata = loadMetadata(matDir);
else
    solution.metadata = struct;
end

% Make interpolator
solution.interpolator = FrameInterpolator(matDir);

% Load Tank
if isfield(solution.metadata, 'tank')
    solution.tank = Tank(solution.metadata);
end

% Load Pattern
if isfield(solution.metadata, 'pattern')
    solution.pattern = Pattern(solution.metadata);
end
