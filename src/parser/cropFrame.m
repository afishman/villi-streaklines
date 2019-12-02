function croppedFrame = cropFrame(frame)
% Tolerance for assessing uniform grid spacing
tol = 1e-5;

croppedFrame = struct;

if ~exist('xlim', 'var')
    xlimits = [-2, 2];
end

if ~exist('ylim', 'var')
    ylimits = [0, 3];
end

if length(xlimits)~=2
    error('xlimits must equal 2 element array')
end

if length(ylimits)~=2
    error('ylimits must equal 2 element array')
end


xDomain = unique(frame.X);
yDomain = unique(frame.Y);

% Find the first elements for x limits
xIdx = [
    find(xDomain>=xlimits(1), 1, 'first'), ...
    find(xDomain>=xlimits(2), 1, 'first')
];

yIdx = [
    find(yDomain>=ylimits(1), 1, 'first'),...
    find(yDomain>=ylimits(2), 1, 'first')
];

% Check that data is uniform
x = xDomain(xIdx(1):xIdx(2));


if (max(diff(diff(x))) > tol)
    error('Only uniform grid spacing is allowed')
end

y = yDomain(yIdx(1):yIdx(2));
if (max(diff(diff(y))) > tol)
    error('Only uniform grid spacing is allowed')
end

crop = @(x) x(yIdx(1):yIdx(2), xIdx(1):xIdx(2));

% Mask
mask = crop(frame.P) == 0;

% Crop each field
fields = fieldnames(frame);
for i=1:length(fields)
    field = fields{i};
    
    % Crop
    cropped = crop(frame.(field));
    
    % Mask
    cropped(mask) = nan;
    
    % Set
    croppedFrame.(field) = cropped;   
end
