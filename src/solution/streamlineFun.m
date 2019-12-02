function dydt = streamlineFun(t, vars, frame)
    method = 'linear';    

    % Split into components
    if mod(length(vars), 2) ~= 0
        error('Uneven number of points')
    end
    numPoints = length(vars)/2;

    x = vars(1:numPoints);
    y = vars(numPoints+1:end);
    
    % Integrates a single particle
    dydt = [
        interp2(frame.X, frame.Y, frame.U, x, y, method);
        interp2(frame.X, frame.Y, frame.V, x, y, method);        
    ];
end