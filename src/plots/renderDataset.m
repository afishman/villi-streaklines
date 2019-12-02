function renderDataset(matDir)

% Render Dataset only
name = 'DataOnly';
solution = Solution(matDir);
%animate(solution, 'render', ['./', name])
%animate(solution, 'render', ['./', name, 'Zoom'], 'xlim', [-5 5], 'ylim', [0,3])

% Slow down 30x
solution.interpolator.timeDelta = 30*solution.interpolator.timeDelta;
disp('animating')
animate(solution, 'render', ['./', name, 'Slow30x'], 'xlim', [-5 5], 'ylim', [0,3])


end
