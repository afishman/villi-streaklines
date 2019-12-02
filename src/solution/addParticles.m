function solution = addParticles(solution, xp, yp)
% function solution = addParticles(solution, xp, yp)
% Function adds particles to solution.
%
% INPUT
%  solution [] Solution object
%  xp [] array of x positions
%  yp [] array of y positions
%
% OUTPUT
%   [] solution containing added particles 


% Check they are the same size
arrSize(xp, yp);

xp = xp(:);
yp = yp(:);

% Ensure no particles start inside a villi
d = distanceToVilli(solution.tank, xp, yp);

% Include in initial condition of solution
solution.xp = [solution.xp;  xp(d>0)];
solution.yp = [solution.yp;  yp(d>0)];