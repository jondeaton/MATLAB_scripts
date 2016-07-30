function [I] = contourInt(funct,s,ds,tspan)
%Numeric Contour Integration trough the complex plane

integrand = @(t) funct(s(t)).*ds(t);
I = integral(integrand,tspan(1),tspan(2));

end