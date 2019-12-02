function [dist, xMin, yMin, villiIdx] = distanceToVilli(tank, xp, yp)
% function [dist, xMin, yMin, villiIdx] = distanceToVilli(tank, xp, yp)
% Min distance to villi boundary
%
% INPUT
%  tank [] Tank struct 
%  xp [] array of x coordinates to test 
%  yp [] array of y coordinates to test
%
% OUTPUT (for each x,y pair)
%  dist, [] min distance
%  xMin, [] x coords of closest villi point
%  yMin, [] y coords of closest villi point 
%  villiIdx [] index of the closest villi

% Calculates the distance to the closest villi given a set of points
% -ve implies inside a villi, +ve outside

% Check input size
s = arrSize(xp, yp);

xp = xp(:);
yp = yp(:);

% Return infs for an empty tank
if isempty(tank)
    dist = inf(s);
    return
end

% Find the nearest 3 neighbours
villiPos = arrayfun(@(x) x.center(1), tank);
posMat = repmat(villiPos, length(xp), 1);
xpMat = repmat(xp, 1, length(villiPos));
[~, closestVilliFromWall] = min(abs(posMat-xpMat), [], 2);

neighbours = [...
    closestVilliFromWall,...
    closestVilliFromWall+1,...
    closestVilliFromWall-1 ...
];

% Calculate the distance to neigbourhood villis, villi-wise
distances = inf(size(neighbours));

xMinMat = inf(size(neighbours));
yMinMat = inf(size(neighbours));

xpDistMat = repmat(xp, 1, size(neighbours, 2));
ypDistMat = repmat(yp, 1, size(neighbours, 2));
for i = 1:length(tank)
    villi = tank(i);
    
    % Gather the points that are in the neigborhood of the villi
    indices = neighbours == i;
    
    x = xpDistMat(indices);
    x = x(:);
    
    y = ypDistMat(indices);
    y = y(:);
    
    % Solve for min distance
    [distances(indices), xMinMat(indices), yMinMat(indices)] = distanceToPoly(villiPolygon(villi), x, y);
end

% Find closest points
[dist, idx] = min(distances, [], 2);

ind = sub2ind(size(distances), 1:size(distances, 1), idx');
xMin = xMinMat(ind);
yMin = yMinMat(ind);
villiIdx = neighbours(ind);

% Reshape
dist = reshape(dist, s);
xMin = reshape(xMin, s);
yMin = reshape(yMin, s);
villiIdx = reshape(villiIdx, s);