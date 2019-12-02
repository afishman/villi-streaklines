function [distance, xMin, yMin] = distanceToPoly(polygon, x, y)
% function [distance, xMin, yMin] = distanceToPoly(polygon, x, y)
% A wrapper around distance2curve that makes it easier to use
%
% INPUT
%  polygon [] polyshape object 
%  x [] array of x coordinates
%  y [] array of y coordinates
%
% OUTPUT 
%  distance, [] min distance to each point
%  xMin, [] x coord of closest point
%  yMin [] y coord of closest point
%


% Determine size
if size(x) ~= size(y)
    error('x and y must have same dimensions')
end
s = size(x);

x = x(:);
y = y(:);

% Close the polygon
curve = polygon.Vertices;
curve = [curve; curve(1,:)];

% Solve for distance
[xy,distance] = distance2curve(curve,[x y]);

inPoly = inpolygon(x, y, curve(:,1), curve(:,2));
distance(inPoly) = -distance(inPoly);

% Reshape
distance = reshape(distance, s);
xMin = reshape(xy(:,1), s);
yMin = reshape(xy(:,2), s);

