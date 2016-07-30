function [blended] = blendIm(oriIm)

dims = size(oriIm);
newIm = zeros(2*dims(1)-1, 2*dims(2)-1,dims(3));
newDims = size(newIm);
filter = zeros(newDims(1),newDims(2));


%Embed
for m = 1:dims(1)
    for n = 1:dims(2)
        newIm(2*m-1,2*n-1,:) = oriIm(m,n,:);
    end
end

%Midpoints
for m = 1:dims(1)
    for n = 1:dims(2)
        %Horizontal
        if(n<dims(2))
            newIm(2*m-1,2*n,:) = (1/2)*(oriIm(m,n+1,:)+oriIm(m,n,:));
        end
        %Vertical
        if(m<dims(1))
            newIm(2*m,2*n-1,:) = (1/2)*(oriIm(m+1,n,:)+oriIm(m,n,:));
        end
    end
end


%CenterPoints
filter =  (1/8)*[1 1 1; 1 0 1; 1 1 1];

for m = 1:dims(1)-1
    for n = 1:dims(2)-1
        
        for j = 1:dims(3)
            slice = newIm(2*m-1:2*m+1,2*n-1:2*n+1,j);
            newIm(2*m,2*n,j) = sum(sum(filter.*slice));
        end
        
    end
end


blended = newIm;




end

