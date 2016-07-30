function f = gammaExt(s)
%Gamma function extended to the complex plane (approximate)

if(isreal(s))
    %For Real Numbers
    f = gamma(s);
else
    Nterms = 100+floor(abs(s));
        %for small arguments
        f = gammaProdExp(s,Nterms);
end

    function prode = gammaProdExp(t,N)
        %Product expansion for gamma function
        prode = zeros(size(t));
        n = 1:N;
        for i = 1:numel(t)
            ti = t(i);
            prode(i) = (1/ti).*prod( ((1 + 1./n).^ti )./(1 + ti./n) );
        end
        
    end

    function summe = gammalnSum(t,N)
        %log of the gamma function calculated by sum
        summe = zeros(size(t));
        n = 1:N;
        for k = 1:numel(t)
            tk = t(k)
            summe(k) = -ln(tk) + tk*sum(ln(1 + 1./n)) - sum(ln(1 + tk./n)); 
        end
        
    end


end

