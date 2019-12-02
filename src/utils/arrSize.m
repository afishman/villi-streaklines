function s = arrSize(arr1, arr2)
    % Returs true if the two arrays are the same size
    % throws an error otherwise
    if(any(size(arr1) ~= size(arr2)))
        error('Arrays must be of equal size')
    end
    
    s = size(arr1);