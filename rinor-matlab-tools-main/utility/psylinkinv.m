function mu = psylinkinv(r,N)
mu = real((1+N*exp(r))./(N*(exp(r)+1)));
end