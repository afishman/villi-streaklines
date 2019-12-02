function animate(solution, varargin)
% Animation Station
% animate(solution) with no additional arguments animates to the screen
% with no background
% 
% animate(__, name, value) specifies additional options as name value pairs
%     'zoomX' : <double> zoom in x direction
%     'zoomY' : <double> zoom in y direction
%     'tSpan' : [a b]    start/end times for animation
%     'render': <string> renders animation into the provided directory. One
%       video is rendered for every variable in ScalarFields.m

% Input args
p = inputParser;
addRequired(p,'solution');
addParameter(p,'render', '');
addParameter(p,'xlim', 'auto');
addParameter(p,'ylim', 'auto');
addParameter(p,'tSpan', []);
addParameter(p,'speed', 1);

% Parse
parse(p, solution, varargin{:});
outDir = p.Results.render;
render = ~isempty(outDir);
xLimits = p.Results.xlim;
yLimits = p.Results.ylim;
tSpan = p.Results.tSpan;
speed = p.Results.speed;

% Other options
frameRate = 30.0;

% Functions to render
videos = cell(0,1);
if render
    mkdir(outDir);
    videos = ScalarFields;

    % Append a VideoWriter instance to each field
    for i = 1:length(videos)
        v = VideoWriter(sprintf('%s%s.avi', outDir, videos{i}.name), 'Motion JPEG AVI');
        videos{i}.video = v;
    end
    
    for i = 1:length(videos)
        open(videos{i}.video);
    end
end

% Determine time span
if(isempty(tSpan))
    if ~isempty(solution.trajectories)
        tSpan = [solution.trajectories.t(1), solution.trajectories.t(end)];

    elseif ~isempty(solution.interpolator)
        tSpan = [0, solution.interpolator.tMax];

    else
        error('Could not determine tSpan')
    end
end

% Figure Settings
hold on
grid on
axis tight manual equal

set(gca,'YDir','normal');
set(gcf, 'Renderer', 'painters');

% Run Animation
fprintf('\nAnimating\n');
fprintf_r('reset')
for t = tSpan(1) : speed/frameRate : tSpan(2)
    % Housekeeping
    fprintf_r("%.2fs / %.2fs", [t, tSpan(2)]);    
    clf    
    
    % Update Tank
    solution.tank = updateTank(solution.tank, solution.pattern, t);

    % Live animation
    if ~render   
        daspect([1,1,1])
        
        if isfield(solution, 'tank')
            % Determine Domain
            vx = arrayfun(@(v) v.center(1), solution.tank);
            vy = arrayfun(@(v) v.center(2), solution.tank);
            vl = arrayfun(@(v) v.length, solution.tank);
            
            xlim(xLimits);
            ylim(yLimits);
        end

        %plotTank(solution.tank)
        plotTrajectories(solution.tank, solution.trajectories, t)
        pause(1/frameRate);
        continue
    end

    % Get field data
    frame = solution.interpolator.interpFrame(t);   

    for i = 1:length(videos)
        % Evaluate function
        fun = videos{i}.fun;
        var = fun(frame);
                              
        % Determine Domain      
        xDomain = unique(frame.X(:));
        yDomain = unique(frame.Y(:));
        
        % Plot image
        imagesc(xDomain, yDomain, var)
        set(gca,'YDir','normal');
        daspect([1,1,1])
        
        % Plot tank
        %plotTank(solution.tank)
        plotTrajectories(solution.tank, solution.trajectories, t)

        % Set caxis
        colorbar
        caxis(videos{i}.clim)
        title(videos{i}.name, 'FontSize', 20);          
      
        % Set x,y limits
        if ischar(xLimits) && contains(xLimits, 'auto')
            xLimits = [min(xDomain) max(xDomain)];
        end
        
        if ischar(yLimits) && contains(yLimits, 'auto')
            yLimits = [min(yDomain) max(yDomain)];
        end

        xlim(xLimits)
        ylim(yLimits)
        
        % Render         
        img = getframe(gcf);
        img = img.cdata;
        
        % Determine image size
        if t == tSpan(1)
            imgSize = size(img);
            imgSize = imgSize(1:2);
        end
        
        % Rescale
        img = imresize(img, imgSize);
        
        % Save
        writeVideo(videos{i}.video, img);
    end
    
end

fprintf('\n Animation Complete \n');

% Close
for i = 1:length(videos)
    close(videos{i}.video);
end
