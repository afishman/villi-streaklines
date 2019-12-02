function v = villiPolygon(villi)
% function v = villiPolygon(villi)
% Function .
%
% INPUT
%  villi [] A Villi struct 
%
% OUTPUT
%   [] Villi polygon as a polyshape object (see: https://uk.mathworks.com/help/matlab/ref/polyshape.html)
%


mainBodyPoly = polyshape([
    villi.width/2
    villi.width/2
    -villi.width/2
    -villi.width/2
], [
    0
    villi.length - villi.width
    villi.length - villi.width
    0
]);

% Model top and bottom with circles
topCapPoly = circlePolygon([0, villi.length - villi.width], villi.width/2);
bottomCapPoly = circlePolygon([0, 0], villi.width/2);

% Unionise
warning('off', 'MATLAB:polyshape:repairedBySimplify')
v = union(bottomCapPoly, union(mainBodyPoly, topCapPoly));
warning('on', 'MATLAB:polyshape:repairedBySimplify')

% Rotation station
v = rotate(v, rad2deg(villi.angle+villi.referenceAngle));

% Translate (traducir)
v = translate(v, villi.center);
