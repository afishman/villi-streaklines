files = listFiles('/Users/aaron/ozstar/particles/', '*.dat*');

t = [];
x = [];
y = [];

for i=1:length(files)
    fprintf('%i of %i\n', i, length(files))
    
    % Get raw data
    fid = fopen(files{i});
    tline = fgetl(fid);
    
    ti = [];
    xi = [];
    yi = [];
    lent = [];
    
    while ischar(tline)
        split= strsplit(tline);
        tline = fgetl(fid);
        ti = str2num(split{2});
        xi(end+1) = str2num(split{3});
        yi(end+1) = str2num(split{4});
    end
    
    t = [t; ti]; 
    x = [x; xi];
    y = [y; yi];
end

%%
csvData = [t x y];
csvData = sortrows(csvData,1);

csvwrite('justin.csv', csvData);