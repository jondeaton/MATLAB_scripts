function index = findStringIndex(StringArr, string)
%FINDSTRING
%finds the indexes of the strings in 'StringArr' that are 'string'

if isrow(StringArr)
    StringArr = StringArr';
end

comparison = strcmp(StringArr,string);

indexes = (1:length(StringArr))'.*comparison;

index = indexes(comparison);
if isempty(index)
    index = -1;
end
    

end

