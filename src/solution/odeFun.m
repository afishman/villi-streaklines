function dydt = odeFun(t, y, interpolator)
% function dydt = odeFun(t, y, interpolator)
% Returns the vector field at the positions of the particles
%
% INPUT
%  t [] current time
%  y [] ode vars
%  interpolator [] ... 
%
% OUTPUT
%   [] dydt
    fprintf('t=%.4f\r', t);

    %% Interpolate to find velocity    
    % Interpolate
    [xp, yp] = unzipOdeVars(y);
    U = interpolator.interp(t, xp, yp, "U");
    V = interpolator.interp(t, xp, yp, "V");
    
    % Velocity
    dydt = zeros(size(y));
    dydt(1 : length(y)/2) = U; 
    dydt(1 + length(y)/2 : end) = V; 
end
