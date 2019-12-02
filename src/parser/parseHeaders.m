function [headers, numHeaderChars] = parseHeaders(filename)
headers = struct;
headers.variables = {};
headers.solutionTime = [];
headers.zone = [];

% Open tecplot file
fid = fopen(filename,'rt');
cleanfid = onCleanup(@() fclose(fid));

% Parse Headers until an empty newline is reached
line = 'INIT';
numHeaderChars = 0;
while ischar(line) && ~isempty(line)
    line = fgetl(fid);
    numHeaderChars = numHeaderChars + length(line) + 1;
    
    if contains(line, 'VARIABLES')
        % Each variable is wrapped in quotes
        vars = regexp(line, '"(.)"', 'tokens');
        
        for v=vars
            headers.variables{end+1} = v{1}{1};
        end
        
    elseif contains(line, 'SOLUTIONTIME')
        % Thanks:https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers
        solutionTime = regexp(line, '([+-]?(?:[0-9]*[.])?[0-9]+)', 'tokens');
        
        if length(solutionTime) ~= 1
            error('Error parsing solution time')
        end
        
        headers.solutionTime = str2double(solutionTime{1}{1});
    
    elseif contains(line, 'ZONE')
        headers.zone = struct;
        
        % Match ZONE fields
        headers.zone.I = str2double(parseField(line, 'I'));
        headers.zone.J = str2double(parseField(line, 'J'));
        headers.zone.datapacking = parseField(line, 'DATAPACKING');
    end
    
    
end

