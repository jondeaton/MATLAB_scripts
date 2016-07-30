function MB = linReg(XDATA,YDATA)
%Linear Regression.
%USE: MB = linReg(XDATA,YDATA)
%     where MB = [m b] fitting YDATA = m*XDATA + b

x = XDATA;
y = YDATA;

M = sum((x-mean(x)).*(y-mean(y)))/sum((x-mean(x)).^2);
B = mean(y - M*x);

MB = [M B];

end

