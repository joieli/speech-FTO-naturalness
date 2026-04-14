function [p,stats] = scatterbox(Y,type,xoffset,ytext,dispName)
arguments
    Y cell
    type (1,:) char = 'basic'
    xoffset double = 0
    ytext = nan
    dispName cell = repmat({''},20)
end

Nb = length(Y);

for i = 1:Nb
    xpos = i*ones(length(Y{i}),1) + xoffset;
    xposjit{i} = jitter(xpos,0.35);
    bc = boxchart(xpos,Y{i},'BoxFaceColor',gca().ColorOrder(i,:),'MarkerColor',[1 1 1 0],...
        'MarkerSize',1,'LineWidth',2,'DisplayName',dispName{i}); % TO DO: remove outliers completely
    hold on
    scatter(xposjit{i},Y{i},30,'k','filled','MarkerFaceAlpha',0.3,...
        'HandleVisibility','off');
    if strcmp(dispName{i},'')
        set(bc,'HandleVisibility','off')
    end

end

switch type
    case 'pairedt'

        assert(Nb==2)
        N = length(Y{1});
        assert(length(Y{2}) == N)
        for i = 1:N
            plot([xposjit{1}(i) xposjit{2}(i)],[Y{1}(i) Y{2}(i)],'Color',0.8*[1 1 1 0.5],...
                'HandleVisibility','off','LineWidth',1.3);
        end

    [~,p,~,stats] = ttest(Y{1},Y{2});
    nSig = sum(p<[0.05 0.01 0.001]);
    if isnan(ytext)
        ytext = max(cell2mat(cellfun(@(x) max(x(~isoutlier(x))),Y,'UniformOutput',false)))*1.2;
    end
    if nSig > 0
        text(xoffset+1.5,ytext,repmat('*',1,nSig),'FontSize',20,'FontWeight','bold','HorizontalAlignment','center')
    else
        text(xoffset+1.5,ytext,'n.s.','FontSize',12,'HorizontalAlignment','center')
    end

    case 'indept'

        assert(Nb==2)

            [~,p] = ttest2(Y{1},Y{2});
    nSig = sum(p<[0.05 0.01 0.001]);
    if isnan(ytext)
        ytext = max(cell2mat(cellfun(@(x) max(x(~isoutlier(x))),Y,'UniformOutput',false)))*1.2;
    end
    if nSig > 0
        text(xoffset+1.5,ytext,repmat('*',1,nSig),'FontSize',20,'FontWeight','bold','HorizontalAlignment','center')
    else
        text(xoffset+1.5,ytext,'n.s.','FontSize',12,'HorizontalAlignment','center')
    end



end
set(gca, 'XGrid', 'off')

