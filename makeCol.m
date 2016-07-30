function col = makeCol(v)
%Makes your row vector into a column
%if its not a row vector, does nothing

col = reshape(v,numel(v),1);

end

