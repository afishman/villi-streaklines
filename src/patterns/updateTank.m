function tank = updateTank(tank, pattern, t)
% function tank = updateTank(tank, pattern, t)
% Function . Update the angles of the villi
%
% INPUT
%  tank [] Tank struct 
%  pattern [] Pattern struct
%  t [] Current time
%
% OUTPUT
%   [] updated Tank struct


    % Nah bother
    if isempty(tank) || isempty(pattern)
        return
    end

    if isempty(t)
        error('No time to update with')
    end

    % Updates the angles of the tank
    angles = num2cell( arrayfun(@(i)pattern(i,t), 1:length(tank)) );
    [tank.angle] = angles{:};
end