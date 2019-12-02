function plotParticles(xp, yp, tank)
    markerSize = 2;
    
    % Put into one array
    s = arrSize(xp, yp);
    
    xp = xp(:);
    yp = yp(:);
    
    % Plot tank
    hold on
    
    % Plot particles, color depending on if they are inside or out of the
    % villi
%     if ~exist('tank', 'var') || isempty(tank)
%         distances = ones(s);
%     else
%         distances = distanceToVilli(tank, xp, yp); 
%     end
    

    plot(xp, yp, 'ko', ...
        'MarkerFaceColor', 'g', ...
        'MarkerSize', markerSize...
    )   

end