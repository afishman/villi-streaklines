function poly = circlePolygon(center, radius, numPts)
    % A circular polygon

    if ~exist("numPts")
        numPts = 100;
    end

    % Angles
    theta = linspace(0, 2*pi, numPts+1);

    x = center(1) + radius*cos(theta);
    y = center(2) + radius*sin(theta);
    
    warning('off', 'MATLAB:polyshape:repairedBySimplify')
    poly = polyshape(x,y);
    warning('on', 'MATLAB:polyshape:repairedBySimplify')
end