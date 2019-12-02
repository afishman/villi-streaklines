function animateEuler(solution, varargin)
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

xLimits = [-2, 2];
yLimits = [0, 3];

% Other options
frameRate = 1/solution.interpolator.timeDelta;

% Functions to render
s = struct;
s.name = 'O';
s.fun = @(x) x.O;
s.clim = [-1 1];

videos = {s};
render = true;
if render
    mkdir(outDir);

    % Append a VideoWriter instance to each field
    for i = 1:length(videos)
        v = VideoWriter(sprintf('%s%s.avi', outDir, videos{i}.name), 'Motion JPEG AVI');
        videos{i}.video = v;
    end
    
    for i = 1:length(videos)
        open(videos{i}.video);
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

numFrames = length(solution.trajectories.t);

for j = 1:numFrames    
    t = solution.trajectories.t(j);
    % Housekeeping
    fprintf_r("%i / %i", [j, numFrames]);    
    clf    
    
    % Update Tank
    solution.tank = updateTank(solution.tank, solution.pattern, solution.trajectories.t(j));

    % Load the new frame
     idx = mod(j-1, length(solution.interpolator.frames))+1;
    loaded = load(solution.interpolator.frameFiles{idx}, 'data');
    frame = loaded.data;
          
    for i = 1:length(videos)
        % Evaluate function
        fun = videos{i}.fun;
%         var = fun(frame);
                              
        % Determine Domain      
        xDomain = unique(frame.X(:));
        yDomain = unique(frame.Y(:));
        
        % Plot image
        plotFrame(frame, fun)
        
        set(gca,'YDir','normal');
        daspect([1,1,1])
        
        % Plot tank
        %plotTank(solution.tank)
        plotTrajectories(solution.tank, solution.trajectories, t);
%         plot(solution.trajectories.x(1:j), solution.trajectories.y(1:j), 'k-')
%         %plot(solution.trajectories.x(j), solution.trajectories.y(j), 'go')
%         
%         x = solution.trajectories.x(j);
%         y = solution.trajectories.y(j);
%         plot([x x], [y y], ...
%             'MarkerEdgeColor', 'k',...
%             'MarkerFaceColor', 'g',...
%             'MarkerSize', 10 ...
%         )
        
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

        xlim([-1, 1.5])
        ylim([0,2])
        
        % Render         
        img = getframe(gcf);
        img = img.cdata;
        
        % Determine image size
        if j == 1
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
