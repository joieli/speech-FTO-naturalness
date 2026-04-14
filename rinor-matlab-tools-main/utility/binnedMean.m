function [xmid,ymean,N,xmean] = binnedMean(x,y,edges)

[N,~,loc]=histcounts(x,edges);
xmean = accumarray(loc(:),x(:))./N';
ymean = accumarray(loc(:),y(:))./N';
% ymean(end+1:numel(edges)-1) = nan;

xmid = 0.5*(edges(1:end-1)+edges(2:end));
