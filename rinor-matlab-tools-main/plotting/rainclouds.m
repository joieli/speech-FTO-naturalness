function h = rainclouds(X,dispName,colOrder)
arguments
    X cell
    dispName cell = repmat({''},1,20)
    colOrder int32 = 1:10
end
n = length(X);
for i = 1:size(X,2)
    
    [f{i}, xi{i}] = ksdensity(X{i});
    h.dx{i} = area(xi{i}, f{i},'HandleVisibility','off'); hold on
    set(h.dx{i}, 'EdgeColor', 'none');
    set(h.dx{i}, 'FaceAlpha', 0.5);
    h.dx{i}.FaceColor = gca().ColorOrder(colOrder(i),:);
end
set(gca,'ytick',[])
yl = get(gca, 'YLim');
set(gca, 'YLim', [0 yl(2)*1.1]);

wdth = yl(2)*0.5;

% mean and quantiles
for i = 1:n
    
    Y{i} = quantile(X{i}, [0.05 0.95 0.5 0 1]);
    startHeight = wdth*0.3;
    offset(i) = (wdth * 0.15) * (i-1) * n;
    h.bx{i,1} = line([Y{i}(1) Y{i}(2)], startHeight + [offset(i) offset(i)], 'col', 'k', 'LineWidth', 2,'DisplayName','$5^{th}$ - $95^{th}$ percentile');

    if ~isempty(dispName{i})
        dispName{i} = [dispName{i} ', '];
    end
    legLabel = [dispName{i} '$\mu$ = ' num2str(round(mean(X{i},'omitnan'),3,'significant'))];
    h.bx{i,2} = scatter(mean(X{i},'omitnan'),startHeight + offset(i), 80,'DisplayName',legLabel);
    h.bx{i,2}.MarkerEdgeColor = [0 0 0];
    h.bx{i,2}.MarkerFaceColor = gca().ColorOrder(colOrder(i),:);
    h.bx{i,2}.LineWidth = 2;
    
end
h.bx{i,1}.HandleVisibility = "off";
    ylabel('Density')
