function [Xk] = DFT(x)
%Descrete Fourier Transform
%X = DFT

N = length(x);

k = (1:N)';
wave = exp(-2i*pi*k/N);

X = zeros(N);
for n = 0:N-1
    X(:,n+1) = (wave).^n;
end

A = zeros(N);
for j = 1:N
   A(j,:) = x; 
end

X = X.*A;

Xk = sum(X,2);

end

