% TODO: Just a hacky script atm
lines = body.g;

vals = [];
for i = 1:length(lines)
    vals = [vals; str2double(strsplit(lines(i)))];
end

plot(vals(:,1), vals(:,2))