function [timeAndDate] = timeDate
%returns the time and the date cool :)

time = fix(clock);

year = num2str(time(1));
month = num2str(time(2));
day = num2str(time(3));
hour = num2str(time(4));
minute = num2str(time(5));
second = num2str(time(6));

date = [day '/' month '/' year];

if (minute < 10)
    mine = strcat('0', num2str(minute));
else
    mine = minute;
end

timeAndDate = [hour ':' mine ' ' date];



end

