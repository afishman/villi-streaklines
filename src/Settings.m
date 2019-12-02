function s = Settings
s = struct;

% Ode solver tolerances
s.relTol = 1e-6;
s.absTol = 1e-8;
s.maxStep = 0.1;

% How often to halt integration and save data
s.saveTime = 0.001;
