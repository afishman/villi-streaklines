classdef SteadyFlowTests < matlab.unittest.TestCase
 
    properties
        StreaklineFigure
        TimeDomainFigure
    end
 
    methods(Test)
        function horizontalFlow(testCase)
            name = 'horizontalFlow';
            
            UFun = @(X,Y) ones(size(X));
            VFun = @(X,Y) zeros(size(X));
            
            matDir = testCase.generateFlowData(name, 0.1, UFun, VFun);
            testCase.testFlow(name, matDir, 0.5, [0, 0.5], [0.5, 0.5])
        
        end
        
        function verticalFlow(testCase)
            name = 'verticalFlow';
            
            UFun = @(X,Y) zeros(size(X));
            VFun = @(X,Y) ones(size(X));
            
            matDir = testCase.generateFlowData(name, 0.1, UFun, VFun);
            testCase.testFlow(name, matDir, 1, [0, 0], [0, 1])
        
        end

        function rigidBodyVortexFlow(testCase)
            name = 'rigidBodyVortexFlow';
            
            UFun = @(X,Y) -2*pi*Y;
            VFun = @(X,Y) 2*pi*X;
            
            matDir = testCase.generateFlowData(name, 0.1, UFun, VFun);
            testCase.testFlow(name, matDir, 1, [-0.5, 0], [-0.5, 0])
            testCase.testFlow(name, matDir, 2.25, [0.1, 0], [0, 0.1])
        
        end
    end
    
    methods
        function matDir = generateFlowData(~, name, resolution, UFun, VFun)
            % Generate 3 frames of uniform flow data in testDir/name
            % flow data defined by fun(X,Y) on [-1,1]x[-1, 1]            
            matDir = sprintf('testData/%s/', name);
            mkdir(matDir);
            
            [X, Y] = meshgrid(-1:resolution:1, -1:resolution:1);
            
            data = struct;
            data.X = X;
            data.Y = Y;
            data.U = UFun(X,Y);
            data.V = VFun(X,Y);
            
            % Save to disk
            for i=1:3
                filename = sprintf('%sframe%i.mat', matDir, i);
                save(filename, 'data')
            end
        end
        
        function testFlow(testCase, name, matDir, duration, initialState, expectedEndState)                       
            solution = Solution(matDir);
            solution.interpolator.looping = true;
            
            % Put particle on middle-left
            solution = addParticles(solution, initialState(1), initialState(2));
            
            % Solve
            solution = trackParticles(solution, [0, duration]);
            actualEndState = [solution.trajectories.x(end), solution.trajectories.y(end)];          
                        
            % Streakline Figure
            figure
            hold on
            grid on
            title([name ': Streakline'])
            frame = solution.interpolator.interpFrame(duration);
            xlabel('x')
            ylabel('y')
            
            % Plot
            quiver(frame.X, frame.Y, frame.U, frame.V)
            plot(expectedEndState(1), expectedEndState(2), 'rx')
            plot(actualEndState(1), actualEndState(2), 'bx')
            plotTrajectories(Tank, solution.trajectories)
            
            legend('flow', 'expected', 'actual', 'streakline')
            
            
            
            % Time Domain Figure
            figure
            hold on
            grid on
            title([name ': Time Domain'])
            xlabel('time')
            plot(solution.trajectories.t, solution.trajectories.x)
            plot(solution.trajectories.t, solution.trajectories.y)
            legend('x', 'y')
            
            % Check tolerance
            testSettings = TestSettings;
            assertEqual(testCase, actualEndState, expectedEndState, ...
                'AbsTol', testSettings.absTol ...
            ); 
        end
    end
 
end