function solution = forwardEuler(solution, fileRoot, loops, seedRate, tStart)
if ~exist('loops', 'var')
    loops = 1;
end

if ~exist('seedRate', 'var')
    seedRate = inf;
end

if ~exist('tStart', 'var')
    tStart = 0;
end

% Close all files after
fids = [];
cleanupObj = onCleanup(@() arrayfun(@(x) fclose(x)));

h = solution.interpolator.timeDelta;

x = [];
y = [];
t = 0;
nextSeed = t;

iterations = round(loops*length(solution.interpolator.frames));

for i=1:iterations
    fprintf("%i of %i\n", i, iterations)
    
    % Add a new seed
    if t>= nextSeed
        x(end+1, :) = solution.xp(:)';
        y(end+1, :) = solution.yp(:)';
        
        filename = sprintf('%s%04i.csv', fileRoot, size(x,1));
        
        % Open it up
        fids(end+1) = fopen(filename, 'w');
        
        nextSeed = nextSeed + seedRate;
    end
    
    % Current index
    idx = mod(i-1, length(solution.interpolator.frames))+1;
    
    % Load the new frame
    loaded = load(solution.interpolator.frameFiles{idx}, 'data');
    frame = loaded.data;
    
    % Set the velocity fields with zero pressure to nan
    if i~=1      
        mask = frame.P == 0;     
        
        frame.U(mask) = nan;
        frame.V(mask) = nan;
    end
    
    % Save
    for j=1:length(fids)
        line = strjoin(arrayfun(@(x) num2str(x), [t x(j,:) y(j,:)],'UniformOutput',false),',');
        fprintf(fids(j), [line, '\n']);
    end
    
    % Step
    U = interp2(frame.X, frame.Y, frame.U, x, y);
    V = interp2(frame.X, frame.Y, frame.V, x, y);  
    
    t = t + h;
    
    if t>=tStart
        x = x + h*U;
        y = y + h*V;
    end   
end

% Save
for j=1:length(fids)
    line = strjoin(arrayfun(@(x) num2str(x), [t x(j,:) y(j,:)],'UniformOutput',false),',');
    fprintf(fids(j), [line, '\n']);
end
