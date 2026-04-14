function mdl = scatterlin(data,dispName,dispStats,idxOutliers,plotFlag)

arguments
    data cell
    dispName cell = repmat({''},20)
    dispStats logical = true
    idxOutliers cell = {}
    plotFlag logical = true
end

N = length(data);
if isempty(dispName); dispName = repmat({''},20); end
if isempty(dispStats); dispStats = true; end


for i = 1:N
    if isempty(idxOutliers)
        idxKeep = true(size(data{i},1),1);
    else
        idxKeep = idxOutliers{i};
    end

    x = data{i}(idxKeep,1);
    y = data{i}(idxKeep,2);

    infidx = isinf(y) | isinf(x);
    x = x(~infidx);
    y = y(~infidx);

    if plotFlag
        if N == 1
            linCol = 'k';
        else
            linCol = gca().ColorOrder(i,:);
        end
        % linCol = iff(N==1,[0 0 0],gca().ColorOrder(i,:));

        scatter(x,y,30,'filled','MarkerFaceAlpha',0.25,...
            'HandleVisibility','off','MarkerFaceColor',linCol);
        hold on

        scatter(data{i}(~idxKeep,1),data{i}(~idxKeep,2),30,'filled','MarkerFaceAlpha',0.25,...
            'HandleVisibility','off','MarkerFaceColor','red');
    end

    mdl{i} = fitlm(x,y);
    p = mdl{i}.Coefficients.pValue('x1');
    nSig = sum(p<[0.05 0.01 0.001]);
    if nSig == 0
        sigStr = 'n.s.';
    elseif nSig == 1
        sigStr = '$p<0.05$';
    elseif nSig == 2
        sigStr = '$p<0.01$';
    elseif nSig == 3
        sigStr = '$p<0.001$';
    end
    R2 = mdl{i}.Rsquared.Adjusted;

    x_new = sort(x);
    [yfit,ci1] = predict(mdl{i},x_new,'Alpha',0.05,'Simultaneous',true);


    if plotFlag
        if dispStats
            statStr = [': $R^2 = ' num2str(round(R2,2,'significant')), '$, ' sigStr];
        else
            statStr = '';
        end
        if isempty(dispName{i})

            legStr = statStr;
        else
            legStr = [dispName{i} statStr];
        end
        plot(x_new,yfit,'Color',linCol,'DisplayName',legStr);
        patx = [x_new; flipud(x_new)];
        paty = [ci1(:,1); flipud(ci1(:,2))];
        if ~all(isnan(ci1(:)))
            patch(patx(~isnan(patx)),paty(~isnan(paty)),'k-','LineWidth',2,'FaceColor',linCol,...
                'FaceAlpha',0.4,'EdgeAlpha',0,'DisplayName','95% CI');
        end
    end
end

if N == 1
    mdl = mdl{1};
end


