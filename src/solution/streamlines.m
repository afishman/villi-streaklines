%% Integrate
clear all

x0 = -2:2;
y0 = ones(1,length(x0));

numPoints = length(x0);

frame = loadFrame('frame1');
duration = 3;
odefun = @(t,y) streamlineFun(t,y,frame);
[t, y] = ode45(odefun, [0,duration], [x0(:); y0(:)]);

%% Plot
figure; hold on
imagesc(unique(frame.X), unique(frame.Y), frame.O)
cbar = colorbar;
caxis([-5,5]);

X = y(:, 1:numPoints);
Y = y(:, numPoints+1:end);

plot(X, Y, 'LineWidth', 7)
plot(X(1,:), Y(1,:), 'rx')
hold on
