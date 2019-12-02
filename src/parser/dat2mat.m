function dat2mat(datDir, matDir, metadata)
% dat2mat: Convert a directory of Tecplot ascii .dat files to binary .mat files
% usage: dat2mat(datDir, matDir)
%
% arguments: (input)
%  datDir - string - Directory of tecplot files. *.dat files are parsed in order of
%  the number at the end of the filename eg {'t0.dat', 't1.dat', 't2.dat', 't10.dat', ...}
%
%  matDir - string - Output directory of binary matlab files. Files are named
%  frame<i>.mat where <i> is the frame number
%  metadata - struct - save metadata along with it

% Housekeeping
datDir = addTrailingSlash(datDir);
matDir = addTrailingSlash(matDir);

if ~exist(matDir, 'dir')
    mkdir(matDir)
end

% Default Metadata
if ~exist('metadata', 'var')
    metadata = Metadata;
end

% Parse each file and store
filenames = listFiles(datDir, 'tecp-T*.dat');
filenames = regexSort(filenames, '(\d+).dat');
for i = 1:length(filenames)
    % Output filename
    inFile = filenames{i};
    outFile = sprintf('%sframe%i.mat', matDir, i);
    
    % Skip if exists
    if exist(outFile, 'file')
        warning('Output file exists. Skipping %s', outFile);
        continue
    end
    
    tic
    
    % Parse
    fprintf('Parsing %s\n', inFile)
    
    [data, t] = parseTecplot(inFile);    
    
    if ~isempty(t)
        metadata.t(end+1) = t;
    end
    
    % Save
    save(outFile, 'data', 't');    
    toc
end

saveMetadata(matDir, metadata);