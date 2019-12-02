function filenames = listFiles(dirName, pattern)
    % List Files given a glob patten
    % e.g. '*.mat'
    
    if exist('pattern', 'var')
        dirName = [addTrailingSlash(dirName), '/', pattern];
    end       
    
    fileInfos = dir(dirName);   
    filenames = cell(length(fileInfos),1);
    
    for i=1:length(fileInfos)
        fInfo = fileInfos(i);
        filenames{i} = [addTrailingSlash(fInfo.folder), fInfo.name];
    end
    
    filenames = sort(filenames);
    
end