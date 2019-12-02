function saveMetadata(matDir, metadata)
% function saveMetadata(matDir, metadata)
% Save dataset metadata to a .mat file
%
% INPUT
%  matDir [] dataset directory
%  metadata [] metadata struct


    save([addTrailingSlash(matDir), 'metadata.mat'], '-struct', 'metadata');
end