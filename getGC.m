function [gc] = getGC(path)
%gives GC content of a summary file from galaxy. GC content of the reads
%argument is the path

A = xlsread(path);
acgt = A(:,14:17);
gc = 100*sum(sum(acgt(:,2:3)))/sum(sum(acgt));

end