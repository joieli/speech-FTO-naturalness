x = -10:0.1:10;
a = 0;
b = 1;
N = 2;
p = (1/N)+(1-1/N)*exp(a+b*x)./(1+exp(a+b*x));

link = @(mu) psylink(mu,N);
linkinv = @(resp) psylinkinv(resp,N);
linkd = @(mu) psylinkd(mu,N);

figure(1);clf;
plot(x,p)
hold on
plot(x,link(p))

%% Example

S.Link = link;
S.Inverse = linkinv;
S.Derivative = linkd;

s = 0.3;
g = 0.01;
P = @(x) min(s+g*max(x,(1/N-s)/g),1);
xx = 0:1:100;
nrep = 5;
yy = rand(numel(P(xx)),nrep) < P(xx)';

X = repmat(xx',nrep,1);
Y = yy(:);

figure(2);clf;
plot(X,Y,'*')

mdl = fitglm(X, Y,'distribution', 'binomial','link',S);
hold on
plot(xx',predict(mdl,xx'))
plot(xx',P(xx))


