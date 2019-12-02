function [value,isterminal, direction] = eventsFun(t, y, tank, pattern)
% function [value,isterminal, direction] = eventsFun(t, y, tank, pattern)
% Events function used when computing a solution. Detects when a particle
% crashes into a villous.
%
% INPUT
%  t [] current time
%  y [] state variable
%  tank [] Tank struct
%  pattern [] Pattern struct
%
% OUTPUT
%  value (distance to nearest villi)
%  isterminal, [] ones (always stop)
%  direction [] zeros (either direction) 
    % Detects when a particle crashes into a villi
    
    % Current State
    tank = updateTank(tank, pattern, t);
    [xp, yp] = unzipOdeVars(y);   
    
    % Value is distance from closest villi
    value = distanceToVilli(tank, xp, yp);
    
    % Terminate!
    isterminal = ones(length(xp), 1);
    direction = [];
end