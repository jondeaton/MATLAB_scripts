function ComplexPlotter
%Interface for plotting a complex function easily
clc; close all;

%=========EDIT HERE=========%

%Number of function evaluations
Neval = 2e5;
% bounds for plotting: [min(x) max(x) min(y) max(y)]
bounds = 6*[-1 1 -1 1];
%Try adjusting this for better images (h=1 is no adjustment)
h = 20;
%Span of
tspan = [-4*pi 4*pi];

%===========================%

%plotCpx(@myFun, Neval, bounds, h, @myPath, tspan);

    function Z = myFun(s)
        
        %===========EDIT HERE=================%
        %Function to be plotted
        %Z = (1+s)./(1+2*s);
        %Z = 1./s;
        Z = gammaExt(s);
        %=====================================%
        
    end


    function path = myPath(t)
        %=========EDIT HERE====%
        %Path to be upon which function is evaluated
        
        
        path = t;
        
        %Circle
        %path = exp(i*t);
        
        %Spiral
        %path = (1+t).*exp(i*2*pi*(1+t));
        
        %Circular saw
        %path = (1+0.1*sin(40*t)).*exp(i*t);
        
        %================%
    end

end

