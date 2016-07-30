function [x_trimmed] = trim_rand(x, n)
%TRIM_RANDOM will randomly remove n entries from x

n = zeroIfNegative(n);

if(n >= numel(x))
    x_trimmed = [];
    return;
else
    x_trimmed = x;
    for i = 1:n
        index = randi(numel(x_trimmed));
        where = zeros(1,numel(x_trimmed));
        where(index) = 1;
        x_trimmed = x_trimmed(~boolean(where));
    end
end

    function f = zeroIfNegative(x)
        %ZEROIFNEGATIVE
        %retuns zero if x is negative, and x if it's non-negative
        
        f = x.*(x >= 0);
    end

end