function solution = backwardEuler(solution)
    
    h = solution.interpolator.timeDelta;
    
    if length(solution.xp)~= 1 || length(solution.yp)~= 1
        error('Can only do one point');
    end
    
    x0 = solution.xp(1);
    y0 = solution.yp(1);
    
    x = [x0];
    y = [y0];
    t = [0];
    errors = [0];
    
    for i=1:length(solution.interpolator.frames)
        fprintf("%i of %i\n", i, length(solution.interpolator.frames))

        frame = solution.interpolator.getFrameByIndex(i);
        
        prev = [x(i) y(i)];
        
        fun = @(x) sum(abs(prev - x + h.*[
            interp2(frame.X, frame.Y, frame.U, x(1), x(2)),...
            interp2(frame.X, frame.Y, frame.V, x(1), x(2)),...
        ]));
        options = optimset('TolX', 1e-8);
        X = fminsearch(fun, prev, options);
        
        x(end+1) = X(1);
        y(end+1) = X(2);
        t(end+1) = t(i) + h;
        errors(end+1) = fun(X);
    end
    
    solution.trajectories = struct;
    solution.trajectories.t = t;
    solution.trajectories.x = x;
    solution.trajectories.y = y;   
    solution.trajectories.errors = errors;
end