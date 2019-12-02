function metadata = loadMetadata(matDir)
    % Loads metadata file from dataset directory
    matDir = addTrailingSlash(matDir);  
    metadata = load([matDir, 'metadata.mat']);
    