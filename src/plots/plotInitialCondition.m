function plotInitialCondition(solution, varargin)
% function plotIC(solution, varargin)
% PLots initial condition, TODO: DRY with animate
%
% INPUT
%  solution [] ...
%  varargin [] 'xlim', [minx maxx], 'ylim', [miny maxy]
%
% OUTPUT
%   [] ...
%


% Input args
p = inputParser;
addRequired(p,'solution');
addParameter(p, 'xlim', 'auto');
addParameter(p, 'ylim', 'auto');

% Parse
parse(p, solution, varargin{:});

xLimits = p.Results.xlim;
yLimits = p.Results.ylim;

% Interpolate
% Interpolate
try
    frame = solution.interpolator.interpFrame(0);
 
catch
    warning('Unable to load velocity fields')
    
    xy = [solution.tank.center];
    x = xy(1:2:end);
    y = xy(2:2:end);
    
    frame = struct;
    [frame.X, frame.Y] = meshgrid(x, y*10);
end

scalarFields = {struct('name', 'Sim', 'fun', @(x) x.O, 'clim', [-1, 1])};

xDomain = unique(frame.X);
yDomain = unique(frame.Y);

for i = 1:length(scalarFields)
    figure
    hold on
    
    % Evaluate function
    fun = scalarFields{i}.fun;
    var = fun(frame);
    
    % Set x,y limits
    if ischar(xLimits) && contains(xLimits, 'auto')
        xLimits = [min(xDomain) max(xDomain)];
    end
    
    if ischar(yLimits) && contains(yLimits, 'auto')
        yLimits = [0 max(yDomain)*3];
    end

    % Plot image
    plotFrame(frame, fun);
    daspect([1,1,1])
    
    % Plot tank    
    plotParticles(solution.xp, solution.yp, solution.tank);
    
    % Set caxis

    title(scalarFields{i}.name, 'FontSize', 20);
    
end
