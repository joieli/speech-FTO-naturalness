close all
clear all

X{1} = [1 2 2 2 2]';
X{2} = ([1 6 5 7 8])';


[p,Tp,To] = permtest(X,1000)

[p,Tp,To] = permtest(X,1000,@(x) median(x))

[p,Tp,To] = permtest(X,1000,@(x) sum(x>mean(x)))

% Llama example:
% A = [7.4 4.4 8.3 4.3 7.2 4.1 7.7 5.8 8.3 7.1 6.2 4.8];

%%
npop = 100000;
nperm = 10000;
B = randn(npop,1);

figure();clf;

for i = 1:nperm
    idx = randi(npop,100,1);

    T(i) = prctile(B(idx),99);
end


histogram(T)
