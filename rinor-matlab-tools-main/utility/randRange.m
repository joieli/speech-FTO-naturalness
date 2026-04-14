function y = randRange(x,n) 
arguments
    x = [0 1]
    n = 1
end

if min(size(x))==1
    m = 1;
else
m = max(size(x));
end

try 
    y = (x(2,:)-x(1,:)).*rand(n,m)+x(1,:);

catch ME
   if (strcmp(ME.identifier,'MATLAB:badsubscript'))
    y = (x(2)-x(1)).*rand(n,m)+x(1);
   else
       error(ME.message)
   end
end
