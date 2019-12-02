function [data, t, headers] = parseTecplot(filename)
% function [data, t] = parseTecplot(filename)
% Parses a ascii tecplot .dat file
%
% INPUT
%  filename [] path to file
%
% OUTPUT
%  data, struct of data frame variables
%  t, SOLUTIONTIME (=[] if not defined)
%  headers, struct
%

data = struct;

[headers, numHeaderChars] = parseHeaders(filename);
t = headers.solutionTime;

% Check datapacking
if ~isempty(headers.zone) && ~strcmp(headers.zone.datapacking, 'BLOCK')
    error('can only parse BLOCK datapacking')
end

% Read entire file, behead, split by common delimiters
text = fileread(filename);
text = strsplit(text(numHeaderChars+1:end));

% Make sure there are variables to parse
if isempty(headers.variables)
    error('TECPLOT PARSE ERROR: no VARIABLES header in %s', filename)
end

% Convert remainder to doubles
doubles = str2double(text);
doubles = doubles(~isnan(doubles));

% Check size
if mod(length(doubles), length(headers.variables))
    error('Numbers parsed (%i) not a multiple of the number of variables (%i)',...
        length(doubles), length(headers.variables) ...
        )
end

% Split into variables
samplesPerVariable = length(doubles) / length(headers.variables);
for i=1:length(headers.variables)
    headerName = headers.variables{i};
    
    startIndex = (i-1)*samplesPerVariable+1;
    endIndex = startIndex + samplesPerVariable-1;
    
    data.(headerName) = doubles(startIndex:endIndex);
end

% Determine domain
xDomain = unique(data.X);
yDomain = unique(data.Y);

% Check against zone
if ~isempty(headers.zone)
    if length(xDomain)~=headers.zone.J
        error('I domain error, expected length of %i (got %i)', headers.zone.J, length(xDomain))
    end
    
    if length(yDomain)~=headers.zone.I
        error('J domain error, expected length of %i (got %i)', headers.zone.I, length(yDomain))
    end
end

% Reshape
for i=1:length(headers.variables)
    headerName = headers.variables{i};
    data.(headerName) = reshape(data.(headerName), length(yDomain), length(xDomain));
end
