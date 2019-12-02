function [xp, yp] = unzipOdeVars(y)
% Separate Ode variables into (x,y) vectors
xp = y(1 : length(y)/2);
yp = y(1 + length(y)/2 : end);