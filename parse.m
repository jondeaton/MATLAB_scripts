function [parts] = parse(str, substr)
%parse('Oh, hello there.','he') returns: {'Oh, ','llo t','re.'}

where = [1-length(substr), strfind(str,substr), length(str)+1];


for j =1:length(where)-1
    parts1{j} = str( (where(j)+length(substr)):(where(j+1)-1) );
end

n = 1;
for k = 1:length(parts1)
    if(length(parts1{k}) ~= 0)
        parts{n} = parts1{k};
        n = n+1;
    end
end


end