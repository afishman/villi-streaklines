function downsampleSim(solution, rate, outDir)


mkdir(outDir)


timeDelta = 1/rate;

% Save new time data
metadata = solution.metadata;
metadata.timeDelta = timeDelta;
saveMetadata(outDir, metadata);

% Interpolate
times = 0:1/rate:solution.interpolator.tMax;
for i=1:length(times)
    fprintf('%i of %i\n', i, length(times))
    data = solution.interpolator.interpFrame(times(i));
        
    t = [];
    path = sprintf('%sframe%i.mat', outDir, i);
    save(path, 'data', 't');
end