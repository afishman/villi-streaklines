function path = addTrailingSlash(path)
    if ~strcmp(path(end), '/') && ~strcmp(path(end), '\')
        path = [path, '/'];
    end
end

