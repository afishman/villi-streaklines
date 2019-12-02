function data = loadFrame(filepath)
% Loads a frame of data

matData = load(filepath);

if ~isfield(matData, 'data')
    error('No data variable in %s', filepath)
end

data = matData.data;