function M = estimate_mode(data)
%ESTIMATE_MODE Summary of this function goes here
%   Detailed explanation goes here

data = reshape(data,1,numel(data));

if(mode(data) ~= min(data))
    M = mode(data);
    return
end

[x,y]=kernel_density(data);
clf; close all; figure(1);
plot(x,y);

M = x(y == max(y));

end

