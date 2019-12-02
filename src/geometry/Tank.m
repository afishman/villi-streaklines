function arr = Tank(metadata, villiAngle)
% Returns an array of villi
arr = [];

% Default empty tank
if ~exist('metadata', 'var')
    return
end

if ~exist('villiAngle', 'var')
    villiAngle = 0.00;
end

% Check metadata
checkFields(metadata, {'tank', 'villi'});
checkFields(metadata.tank, {'spacing', 'numVilli'});
checkFields(metadata.villi, {'length', 'width'});

% Calculate Sim Units (Villi lengths)
normFactor = 1;
widthSimUnits = metadata.villi.width * normFactor;
lengthSimUnits = metadata.villi.length * normFactor;
spacingSimUnits = metadata.tank.spacing * normFactor;

centerSimUnits = 1.1*widthSimUnits;

arr = Villi(lengthSimUnits, widthSimUnits, villiAngle, [0, centerSimUnits], 0);

% Assuming odd
for i=1:floor(metadata.tank.numVilli/2)
    arr(end+1) = Villi(lengthSimUnits, widthSimUnits, villiAngle, [i*spacingSimUnits, centerSimUnits]);
    arr(end+1) = Villi(lengthSimUnits, widthSimUnits, villiAngle, [-i*spacingSimUnits, centerSimUnits]);
end

% Sort villi left-to-right
pos = arrayfun(@(x) x.center(1), arr);
[~, reindex] = sort(pos);
arr = arr(reindex);
