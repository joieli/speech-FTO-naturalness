function y = sigmoid(x,k,x0)
arguments
    x double 
    k double = 1
    x0 double = 0
end
y = 1./(1+exp(-k*(x-x0)));