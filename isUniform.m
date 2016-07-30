function uniform  = isUniform(X)

uniform = 0 == sum(sum(X ~= X(1)));

end

