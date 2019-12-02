function scalarFields = ScalarFields
% function scalarFields = ScalarFields
% Returns struct array containing functions on the vector field used for visualisation, as
%

% Returns a cell array of functions

scalarFields = {
%    struct('name', 'Sim', 'fun', @(x) 0.4, 'clim', [0, 1])
%     struct('name', 'Vorticity', 'fun', @(x) x.O, 'clim', [-5, 5])
%     struct('name', 'Pressure', 'fun', @(x) x.P, 'clim', [-0.2, 0.2])
     struct('name', 'Horizontal Velocity', 'fun', @(x) x.U, 'clim', [-0.4, 0.4])
     struct('name', 'Vertical Velocity', 'fun', @(x) x.V, 'clim', [-0.6, 0.6])
%     struct('name', 'Kinetic Energy', 'fun', @(x) sqrt(x.V.^2 + x.U.^2), 'clim', [0, 0.5])
};