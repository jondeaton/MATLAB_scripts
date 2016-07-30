function [rounded] = roundN(x,decimal)
%round(3.1415,3) 
%returns 3.142

rounded = round(x*10^decimal)/10^decimal;


end

