function resampled = resampleFrame(frame)
% Resamples a frame to unifrm grid spacing

resampled = struct;

uniqueX = unique(frame.X(:));
uniqueY = unique(frame.Y(:));

dx = min(diff(uniqueX));
dy = min(diff(uniqueY));

x = uniqueX(1) : dx : uniqueX(end);
y = uniqueY(1) : dy : uniqueY(end);

[X, Y] = meshgrid(x, y);

fields = fieldnames(frame);
for i=1:length(fields)
    field = fields{i};
    
    resampled.(field) = interp2(frame.X, frame.Y, frame.(field), X, Y);
end
