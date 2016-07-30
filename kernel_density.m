function [X, Y] = kernel_density(data, varargin)
%KERNEL DENSITY ESTIMATION

data = reshape(data, 1, numel(data));

switch nargin
    case 1
        bandwidth = select_bandwidth(data);
        kernel = 'Epanechnikov';
    case 2
        arg = varargin{1};
        if ischar(arg)
            kernel = arg;
            bandwidth = select_bandwidth(data);
        else
            bandwidth = arg;
            kernel = 'Epanechnikov';
        end
    case 3
        bandwidth = varargin{1};
        kernel = varargin{2};
    otherwise
        error('Too many input arguments');
end

%Kernel Selection
switch kernel
    case 'Normal'
        Kh = @Kh_Normal;
    case 'Epanechnikov'
        Kh = @Kh_Epanechnikov;
    case 'Uniform'
        Kh = @Kh_Uniform;
    case 'Triangular'
        Kh = @Kh_Triangular;
    case 'Quadratic'
        Kh = @Kh_Quadratic;
    case 'Triweight'
        Kh = @Kh_Triweight;
    case 'Tricube'
        Kh = @Kh_Tricube;
    case 'Cosine'
        Kh = @Kh_Cosine;
    case 'Logistic'
        Kh = @Kh_Logistic;
    case 'Silverman'
        Kh = @Kh_Silverman;
    otherwise
        error('Unknown Kernel');
end

xlo = min(data) - 0.5*range(data);
xhi = max(data) + 0.5*range(data);
dx = (xhi-xlo)/(100 + 3*numel(data));
X = xlo:dx:xhi;
N = numel(data);
Y = zeros(size(X));

for i = 1:length(X)
    u = (X(i)-data)/bandwidth;
    Y(i) = sum(Kh(u))/N;
end
Y = Y/sum(Y*dx);

%Selects a good Bandwidth for
    function bw = select_bandwidth(data)
        n = numel(data);
        bw = 1.06*std(data)*n^(-1/5);
    end

%All the different kinds of kernels
    function Kh = Kh_Normal(u)
        Kh = (1/bandwidth)*exp(-u.^2./2)/sqrt(2*pi);
    end

    function Kh = Kh_Epanechnikov(u)
        Kh = (1/bandwidth)*(3/4)*(1-u.^2).*(abs(u)<=1);
    end

    function Kh = Kh_Uniform(u)
        Kh = (1/bandwidth)*(1/2)*(abs(u)<=1);
    end

    function Kh = Kh_Triangular(u)
        Kh = (1/bandwidth)*(1-abs(u)).*(abs(u)<=1);
    end

    function Kh = Kh_Quadratic(u)
        Kh = (1/bandwidth)*(15/16)*(1-u.^2).^2.*(abs(u)<=1);
    end

    function Kh = Kh_Triweight(u)
        Kh = (1/bandwidth)*(35/32)*(1-u.^2).^3.*(abs(u)<=1);
    end

    function Kh = Kh_Tricube(u)
        Kh = (1/bandwidth)*(70/81)*(1-abs(u).^3).^3.*(abs(u)<=1);
    end

    function Kh = Kh_Cosine(u)
        Kh = (1/bandwidth)*(pi/4)*cos(pi*u/2).*(abs(u)<=1);
    end

    function Kh = Kh_Logistic(u)
        Kh = (1/bandwidth)*1./(2*cosh(u)+2);
    end
    
    function Kh = Kh_Silverman(u)
        Kh = (1/bandwidth)*(1/2)*exp(-abs(u)/sqrt(2)).*sin(abs(u)/sqrt(2)+pi/4);
    end

end


