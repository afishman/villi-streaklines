function parseJustin(directory, outfile)


% directory = '/Volumes/Oarfish/villi/SimData/ozstar/particles/phaseRe2000/';
% outfile = './re2000/re2000.csv';


files = listFiles(directory, '*.dat_*');

xLines = {};
yLines = {};
idLines = {};
tLines = [];

for i=1:length(files)
    fprintf('%i of %i\n', i, length(files))
    
    % Get raw data
    fid = fopen(files{i});
    tline = fgetl(fid);
    
    idLine= [];
    tLine = [];
    xLine = [];
    yLine = [];
    
    while ischar(tline)
        split= strsplit(tline);
        tline = fgetl(fid);
        
        idLine(end+1) = 1+round(str2num(split{1}));
        tLine = str2num(split{2});
        xLine(end+1) = str2num(split{3});
        yLine(end+1) = str2num(split{4});
    end
    
    tLines(end+1) = tLine;
    idLines{end+1} = idLine;
    xLines{end+1} = xLine;
    yLines{end+1} = yLine;
    
    
%     if i==1
%         num_particles = max(idLine);
%     end
    

end

%% Organise
num_particles = max(cellfun(@(x) max(x), idLines));

t = tLines';
x = nan(length(t), num_particles);
y = nan(length(t), num_particles);

for i=1:length(tLines)
    xi = xLines{i};
    yi = yLines{i};
    idi = idLines{i};
    
    for j=1:length(xi)        
        x(i, idi(j)) = xi(j); 
        y(i, idi(j)) = yi(j); 
    end
    
end


%%
csvData = [t x y];
csvData = sortrows(csvData,1);

csvwrite(outfile, csvData);