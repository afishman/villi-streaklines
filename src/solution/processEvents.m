function [xRestart, yRestart] = processEvents(sol)

% Initialise restart state
numParticles = size(sol.y, 1)/2;
xRestart = sol.y(1:numParticles, end);
yRestart = sol.y(1+numParticles:end, end);

% Nah bother
if isempty(sol.ie)
    return
end

% Sort events by time
[~, sortedXeIdx] =  sort(sol.xe);

% Process each event
for i = sortedXeIdx    
    xRestart(sol.ie(i)) = nan;
    yRestart(sol.ie(i)) = nan;
    
    % OFFSET TECHIQUE
%     % Find the villi that has been collided into
%     [~, ~, ~, villiIdx] = distanceToVilli(tank, x(i), y(i));
%     villi = tank(villiIdx);
%     % Offset villi
%     offsetPoly = polybuffer(villiPolygon(villi), offset);
%     
%     % Find the nearest point
%     [~, xMin, yMin] = distanceToPoly(offsetPoly, x(i), y(i));
% 
%     % Update Restart State
%     xRestart(i) = xMin;
%     yRestart(i) = yMin;
end