function t = kTauB(x,y,w)

N = numel(x);
assert(numel(y)==N)
assert(all(abs(x)==1 |x==0))
assert(all(abs(y)==1 |y==0))

if ~exist('w','var')
    w = ones(N,1);
end


P = x==y & x~=0 & y~=0;
Q = x~=y & x~=0 & y~=0;
X0 = x==0 & y~=0;
Y0 = y==0 & x~=0;
XY0 = y==0 & x==0;

assert(all(ones(N,1) == P|Q|X0|Y0|XY0));

t = (sum(P.*w)-sum(Q.*w))./sqrt(sum(P|Q|X0)*sum(P|Q|Y0));