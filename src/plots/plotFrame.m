function cbar = plotFrame(frame, varOrfield)
croppedFrame = cropFrame(frame);

showColorbar = true;

villiMask = isnan(croppedFrame.P);
villiImg = ones(size(croppedFrame.X));
villiImg(villiMask) = 0;





% Plot
if ~exist('varOrfield', 'var')
    showColorbar = false;  
    cdata = [];
    
elseif ischar(varOrfield) || isstring(varOrfield)
    cdata = croppedFrame.(varOrfield);
else
    cdata = varOrfield(croppedFrame);
end

xDomain = unique(croppedFrame.X);
yDomain = unique(croppedFrame.Y);
x = [min(xDomain), max(xDomain)];
y = [min(yDomain), max(yDomain)];

if ~isempty(cdata)
    imagesc(x, y, cdata)
    set(gca, 'YDir', 'Normal')
end

if showColorbar
    cbar = colorbar
else
    cbar = []
end

s = size(villiImg);
img = zeros([s(1), s(2), 3]);
img(:,:,1) = villiImg;
img(:,:,2) = villiImg;
img(:,:,3) = villiImg;
h = image(x, y, img);
set(h, 'AlphaData', villiMask);
