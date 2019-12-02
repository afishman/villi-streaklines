function plotSolution(solution, varargin)

    % Input args
    p = inputParser;
    addRequired(p,'solution');
    addParameter(p,'t', []);
    addParameter(p,'xlim', 'auto');
    addParameter(p,'ylim', 'auto');
    addParameter(p,'trajectories', true);
    addParameter(p,'tank', true);
    
    % Parse
    parse(p, solution, varargin{:});
    
    showTrajectories = p.Results.trajectories;
    t = p.Results.t;
    xlimits = p.Results.xlim;
    ylimits = p.Results.ylim;
    tankPlot = p.Results.tank;

    % Set t
    if isempty(solution.trajectories.t)
        error('no solutions found in trajectories')
    end  
    t = solution.trajectories.t(end-1);
    
    % Interpolate
    try
        frame = solution.interpolator.interpFrame(t);
        scalarFields = ScalarFields;    
    
    catch
        warning('Unable to load velocity fields')
        
        xy = [solution.tank.center];
        x = xy(1:2:end);
        y = xy(2:2:end);
        
        frame = struct;
        [frame.X, frame.Y] = meshgrid(x, y*10);
        scalarFields = {struct('name', 'Sim', 'fun', @(x) 0, 'clim', [0, 1])};
        
    end
    
       
    
    for i = 1:length(scalarFields)
        figure
        hold on
        
        % Evaluate function
        fun = scalarFields{i}.fun;
        var = fun(frame);
                              
        % Determine Domain      
        xDomain = unique(frame.X(:));
        yDomain = unique(frame.Y(:));
        
        % Plot image
        plotFrame(frame, fun);
       
        daspect([1,1,1])

        
        if showTrajectories
            plotTrajectories(solution.tank, solution.trajectories, t)
        end
        
        % Set caxis
        colorbar
        caxis(scalarFields{i}.clim)
        title(scalarFields{i}.name, 'FontSize', 20);          
      
        xlim(xlimits)
        ylim(ylimits)
    end
end