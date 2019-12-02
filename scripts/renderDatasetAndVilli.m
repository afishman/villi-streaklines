%matDir = 'path_to_matDir';

%% Render Dataset + Villi Movement, 
name = './DataAndTank';
solution = Solution(matDir);
animate(solution, 'render', name, 'zoomX', 0.25, 'zoomY', 2)
