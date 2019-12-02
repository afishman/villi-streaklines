% Check the distance to villi algorithm works
n=1000;
gradi = 0.2;

villi = Villi(1, 0.25, 0, [0,0]);
x = linspace(-.8, 0.8, n);
y = linspace(-0.25, 1.25, n);

[X, Y] = meshgrid(x,y);

d = distanceToVilli(villi, X, Y);

prop = abs(min(d(:))) / (max(d(:)) - min(d(:)));

hold on
imagesc(x,y,d);
plot(villiPolygon(villi));
daspect([1,1,1])
cMapSize = 100;
numGreen = round(prop*cMapSize);
numRed = cMapSize - numGreen;

greenMap = zeros(numGreen,3);
greenMap(:,1) = linspace(gradi, 1, numGreen);

redMap = zeros(numRed,3);
redMap(:,2) = linspace(1, gradi, numRed);

cMap = [
    greenMap;
    redMap
];

colormap(cMap);
colorbar;
xlim([min(x), max(x)])
ylim([min(y), max(y)])
