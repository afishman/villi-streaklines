function v = Villi(len, width, angle, center, referenceAngle)
% function v = Villi(len, width, angle, center, referenceAngle)
%   Returns a struct that represents the state of a villus 
%
% INPUT
%  len [] total villi length 
%  width [] villi width 
%  angle [] angle of villi 
%  center [] coords of the center of rotation 
%  referenceAngle [] angle of 0 rotation 
%
% OUTPUT
%   [] Villi struct


% Defaults
if ~exist('angle', 'var')
    center = 0;
end

if ~exist('center', 'var')
    center = [0,0];
end

if ~exist('referenceAngle', 'var')
    referenceAngle = 0;
end

% Construct
v = struct;
v.center = center;
v.length = len;
v.width = width;
v.angle = angle;
v.referenceAngle = referenceAngle;