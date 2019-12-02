function checkFields(structure, fields)
    % Asserts that fields exist in the structure
    % Fields is a cell array / string of required fields
    % Throws an error is any are missing
    if isa(fields, 'char')
        fields = {fields};
    end   
    
    missingFields = cell(0,1);
    for i = 1:length(fields)
        if ~isfield(structure, fields{i})
            missingFields{end+1} = fields{i};
        end
    end
    
    if ~isempty(missingFields)
        error(['Missing Fields ' strjoin(missingFields, ', ')]);
    end
end