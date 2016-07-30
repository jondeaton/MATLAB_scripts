function [rgbImage] = complex2RGB(A, h)
%RBGIm = complex2RGB(A,h)
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

%Color Adjustment (by h)
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