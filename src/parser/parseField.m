function value = parseField(str, field)
% parses a ZONE field with pattern <field>=<value>
% throws an error on failue
%
% INPUT
%  str [] string to parse
%  fieldname [] name of the field
%
% OUTPUT
%   [] value of field 

% Match J 
match = regexp(str, [field '=(\w+)'], 'tokens');
if isempty(match)
    error('no %s field in ZONE header', field);
end
value = match{1}{1};
