function [p,Tperm,Tobs,idxPerm] = permtest(X,Np,statFun,distFun,type,rngN)
arguments
    X cell
    Np = 10000;
    statFun = @(x) mean(x,'omitnan')
    distFun = @(t1,t2) abs(t1-t2)
    type (1,:) char = 'indep'
    rngN = 'shuffle'
end

if isempty(Np); Np = 10000; end
if isempty(statFun); statFun = @(x) mean(x,'omitnan'); end
if isempty(distFun); distFun = @(t1,t2) abs(t1-t2); end

% Check number of arguments to functions

for m = 1:2
if size(X{m},1) < size(X{m},2)
    X{m} = X{m}';
end
end

n1 = size(X{1},1);
n2 = size(X{2},1);
Ntot = n1+n2;

Tobs = distFun(statFun(X{1}),statFun(X{2}));
Tperm = zeros(Np,1);

switch type
    case 'paired'
        Xboth = [X{1} X{2}];
        assert(size(X{1},2)==1)
        assert(size(X{2},2)==1)

        for i = 1:Np
            Xperm = shuffle(Xboth,2);
            Tperm(i) = distFun(statFun(Xperm(:,1)),statFun(Xperm(:,2)));

            % Display progress
            if mod(i,100)==0
                disp(['permtest: ' num2str(i/Np*100) '% done'])
            end
        end

    case 'indep'
        Xboth = [X{1};X{2}];

        for i = 1:Np
            rng(rngN+i)
            idxPerm{i} = randperm(Ntot);
            idx1 = idxPerm{i}(1:n1);
            idx2 = idxPerm{i}(n1+1:end);
            Tperm(i) = distFun(statFun(Xboth(idx1,:)),statFun(Xboth(idx2,:)));

            % Display progress
            % if mod(i,100)==0
            %     disp(['permtest: ' num2str(i/Np*100) '% done'])
            % end
        end
end

p = mean(Tobs <= Tperm);

% if nargout == 0
% figure();
% h = histogram(Tperm);
% e = h.BinEdges;
% histogram(Tperm(Tobs>Tperm),e)
% hold on
% histogram(Tperm(Tobs<=Tperm),e)

