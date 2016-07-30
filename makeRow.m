function row = makeRow(v)
%Makes your column vector into a row
%if its not a column, it does nothing

row = reshape(v, 1, numel(v));

end

