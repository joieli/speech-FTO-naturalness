function out = binormal(in,mu,sig,lapse)
out = normcdf(mu+sig.*norminv(in))*lapse;%+(1-lapse)/2;
end

%% See also: https://math.stackexchange.com/questions/1832177/sigmoid-function-with-fixed-bounds-and-variable-steepness-partially-solved