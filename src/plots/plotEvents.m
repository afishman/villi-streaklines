function plotEvents(tank, pattern, offset, xeOrSol, ye, ie)
    % Plot the event of a particle crashing into a villi
    markerSize = 8;    

    % Can provide sol struct or data directly
    if isa(xeOrSol, 'struct')
        sol = xeOrSol;
        xe = sol.xe;
        ye = sol.ye;
        ie = sol.ie;

    elseif isa(xeOrSol, 'double')
        xe = xeOrSol;

        if nargin ~= 3
            error('Must provide ye and ie')
        end
    end

    % Update tank state
    tank = updateTank(tank, pattern, xe);

    % Process event
    [xRestart, yRestart] = processEvents(tank, pattern, offset, sol);

    % Plot

    hold on
    plotTank(tank)

    % Plot Offset Polys
    offsetVilliPoly = arrayfun(@(v) polybuffer(villiPolygon(v), offset), tank);
    for poly = offsetVilliPoly
        plot(poly)
    end

    % Get positions
    [x, y] = unzipOdeVars(ye);

    % Plot
    eventIdx = ismember(1:length(x), ie);

    plot(x(~eventIdx), y(~eventIdx), 'ko', ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', markerSize...
    )

    plot(x(eventIdx), y(eventIdx), 'ko', ...
        'MarkerFaceColor', 'r', ...
        'MarkerSize', markerSize...
    )

    plot(xRestart(eventIdx), yRestart(eventIdx), 'ko', ...
        'MarkerFaceColor', 'g', ...
        'MarkerSize', markerSize...
    )
end