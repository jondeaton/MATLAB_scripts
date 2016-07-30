function f = zeroIfNegative(x)
%ZEROIFNEGATIVE
%retuns zero if x is negative, and x if it's non-negative

f = x.*(x >= 0);

end