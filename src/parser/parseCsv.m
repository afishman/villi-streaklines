function [t x y] = parseCsv(data)

l = length(data)/3;

i = 1;

t = data(i:i+l-1);
i = i+l;

x = data(i:i+l-1);
i = i+l;

y = data(i:i+l-1);
i = i+l;
