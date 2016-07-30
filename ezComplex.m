function ezComplex(funct, varargin)
%Easy plotting of functions with complex arguments and outputs.
%
%USE:ezComplex(myInlineFunction)
%to show a color image of the function output (with a reference image),
%and a 3D redering of the function's magnitude over the complex plane.
%
%Example:
%               ezComplex('exp(s.^2)');
%
%%The function will be plotted from Re(s) = (-7, 7) and Im(s) = (-7i, 7i)
%
%OR: ezComplex(myInlineFun,myInlinePathFun)
%to also generate a plot of the path through the complex plane, the real
%and imaginary parts of the output as t, and
%
%Example:
%               ezComplex('log(s)','exp(i*t)')
%
%The path will be plotted for t = (-pi, pi)
%
%Other:
%The function will be evaluates ~2E5 times (so don't use zeta(s) unless
%you are prepared to wait a very long time), and the output image is 
%auto adjusted such that the average intsity of all of the pixles is ~0.75
%
%Created by Jon Deaton
%Date Created: 1/4/15

fun = inline(funct);

Neval = 2e5;

bounds = 7*[-1 1 -1 1];

%Rename bounding variables
relo = bounds(1);
rehi = bounds(2);
imlo = bounds(3);
imhi = bounds(4);

%Create Real and Imaginary Axes for function evaluation
dimRatio = (rehi - relo)/(imhi - imlo);
realAx = linspace(relo,rehi,floor(sqrt(dimRatio*Neval)));
imagAx = linspace(imhi,imlo,floor(sqrt(Neval/dimRatio)));
[x,y] = meshgrid(realAx, imagAx);
s = x + i*y;

%Function Evaluation
Z = fun(s);

%Make sure that Z isn't a scalar
if(size(Z) == 1)
    Z = ones(size(s))*fun(s);
end

%Make infinite values the maximum(white), and NaN values zero(black)
if(sum(sum(~isfinite(Z) + isnan(Z))) > 0 )
    fMax = max(max(abs(Z)));
    Z(~isfinite(Z)) = fMax;
    Z(isnan(Z)) = 0;
end

%Generation of RGB image (and auto-adjustment)
averageIntensity  = 0.5; %aproximate average intensity of image
tol = 0.05;
h = 1;
im = complex2RGB(Z,h);
avg = mean(mean(mean(im)));
while(abs(log(h)) < 10 && abs(avg - averageIntensity) > tol)
    h = h*exp(averageIntensity - avg);
    im = complex2RGB(Z,h);
    avg = mean(mean(mean(im)));
end

%Reference Image Creation
fMax = max(max(abs(Z)));
bound = fMax / sqrt(2);
reRef = linspace(-bound,bound,floor(sqrt(Neval)));
imRef = linspace(bound,-bound,floor(sqrt(Neval)));
[xRef, yRef] = meshgrid(reRef, imRef);
sRef = xRef + i*yRef;
reference = complex2RGB(sRef, h);

%======================= Figure Generation =======================%

%==============Reference==================%
figure(1);
imshow(reference);
fontsize = 14;
title('Color Reference','fontsize',fontsize)

xlabel('Real Axis','fontsize',fontsize);
ylabel('Imaginary Axis','fontsize',fontsize);

text(0.03*sqrt(Neval),(1-0.1)*sqrt(Neval),'Black = 0');
text(0.03*sqrt(Neval),(1-0.05)*sqrt(Neval),...
    sprintf('White (Function Maximum) = %.2d',max(max(abs(Z)))));

text((0.8)*sqrt(Neval),(0.5)*sqrt(Neval),sprintf('%.1d',bound));
text((0.42)*sqrt(Neval),0.05*sqrt(Neval),sprintf('%0.1d i',bound));

%=================Function Output=================%
figure(2);
imshow(im);
title('Function Output','fontsize',fontsize);
xlabel(sprintf('Real Axis: (%.1f to %.1f)',relo,rehi),...
    'fontsize',fontsize);
ylabel(sprintf('Imaginary Axis: (%.1f to %.1f)',imlo,imhi),...
    'fontsize',fontsize);

%======================3D Plot=========================%
figure(3);
reduction = Neval/1000;
xDATA = sample(x,reduction);
yDATA = sample(y,reduction);
zDATA = abs(sample(Z,reduction));
surf(xDATA,yDATA,zDATA);
title('Function Output Magnitude','fontsize',fontsize);
xlabel('Real Axis','fontsize',fontsize);
ylabel('Imaginary Axis','fontsize',fontsize);
zlabel('Magnitude');

%=============Path Plots=============%
if(~isempty(varargin))
    pathFun = inline(varargin{1});
    tspan = [-pi pi];
    
    t = linspace(tspan(1),tspan(2),sqrt(Neval));
    path = pathFun(t);
    Zpath = fun(path);
    
    figure(4);
    plot(real(path),imag(path),'linewidth',2);
    title('Path','fontsize',fontsize);
    xlabel('Real Axis','fontsize',fontsize);
    ylabel('Imaginary Axis','fontsize',fontsize);
    axis([relo rehi imlo imhi]);
    grid on;
    
    figure(5);
    hold on;
    plot(t,real(Zpath),'-k');
    plot(t,imag(Zpath),'-r');
    title('Output as t','fontsize',fontsize);
    xlabel('t');
    ylabel('Magnitude','fontsize',fontsize);
    legend('real part','imaginary part');
    grid on;
    
    figure(6);
    plot(real(Zpath),imag(Zpath));
    title('Function Output on Path','fontsize',fontsize);
    xlabel('Real Axis','fontsize',fontsize);
    ylabel('Imaginary Axis','fontsize',fontsize);
    grid on;
end


    function [rgbImage] = complex2RGB(A, h)
        %This function takes in matrix A of complex numbers and returns a
        %corresponding RGB M by N by 3 matrix
        %Black will always be zero, and white will be the function maximum.
        %
        %The parameter h is for color adjustment:
        %h = 1 is unadjusted
        %higher h makes differences in magnitudes of mid-range complex numbers less
        %pronounced
        
        angles = angle(A);
        angles = mod(angles,2*pi);
        angles = angles*(180/pi);
        
        mags = abs(A);
        
        black = 0;
        white = max(max(mags));
        
        %For dealing with uniform magnitudes
        if(isUniform(mags))
            white = sqrt(2)*white;
        end
        
        
        saturation = ((white - mags)/(white - black)).^h;
        value = ((mags - black)/(white - black)).^(1/h);
        
        dims = size(angles);
        
        Red = zeros(dims);
        Green = zeros(dims);
        Blue = zeros(dims);
        
        rgbImage = zeros(dims(1),dims(2),3);
        
        low  = value.*(1-saturation);
        high = value;
        
        slope = (high - low)/60;
        
        region1 = find(angles <= 60);
        region2 = find((angles > 60) .* (angles <= 120));
        region3 = find((angles > 120) .* (angles <= 180));
        region4 = find((angles > 180) .* (angles <= 240));
        region5 = find((angles > 240) .* (angles <= 300));
        region6 = find((angles > 300) .* (angles <= 360));
        
        %0 to 60 degrees
        Red(region1) = high(region1);
        Green(region1) = low(region1) + slope(region1).*angles(region1);
        Blue(region1) = low(region1);
        
        %60 to 120 degrees
        Red(region2) = high(region2) - slope(region2).*(angles(region2) - 60);
        Green(region2) = high(region2);
        Blue(region2) = low(region2);
        
        %120 to 180 degrees
        Red(region3) = low(region3);
        Green(region3) = high(region3);
        Blue(region3) = low(region3) + slope(region3).*(angles(region3) - 120);
        
        %180 to 240 degrees
        Red(region4) = low(region4);
        Green(region4) = high(region4) - slope(region4).*(angles(region4) - 180);
        Blue(region4) = high(region4);
        
        %240 to 300 degrees
        Red(region5) = low(region5) + slope(region5).*(angles(region5) - 240);
        Green(region5) = low(region5);
        Blue(region5) = high(region5);
        
        %300 to 360 degrees
        Red(region6) = high(region6);
        Green(region6) = low(region6);
        Blue(region6) = high(region6) - slope(region6).*(angles(region6) - 300);
        
        rgbImage(:,:,1) = Red;
        rgbImage(:,:,2) = Green;
        rgbImage(:,:,3) = Blue;
        
        
        function uniform  = isUniform(X)
            
            uniform = 0 == sum(sum(X ~= X(1)));
            
        end
        
    end


    function [v] = sample(V,r)
        %SAMPLE, will reduce the size of vector V by factor r
        % example, r = 3, makes V 1/3 the size.
        %Note: This function doesn't really work super well... haha
        
        if(r < 1)
            r = 1;
        end
        if(isvector(V))
            leng = prod(size(V));
            where = ~floor(mod(1:leng,r));
            index = find(where);
            v = V(index);
        else
            r = ceil(sqrt(r));
            dims =  size(V);
            m = dims(1);
            n = dims(2);
            
            index1 = find(~floor(mod(1:m,r)));
            
            for i = 1:length(index1)
                index2 = find(~floor(mod(1:n,r)));
                v(i,:) = V(index1(i),index2);
            end
        end
    end

end