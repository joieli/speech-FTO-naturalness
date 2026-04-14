function latexFormat(figs,dollarBool)

arguments
    figs = findobj('Type','figure');
    dollarBool logical = true
end

if isempty(figs)
    figs = findobj('Type','figure');
end
nF = numel(figs);
[~,sidx] = sort([figs.Number]);
sfigs = figs(sidx);

if dollarBool
for f = 1:nF
    fig = sfigs(f);
axes = findall(fig.Children,'type','Axes');
    nAx = numel(axes);

    for ax = 1:nAx
        axe = axes(ax);

        if any(axe.YLabel.String == '$')
            axe.YLabel.Interpreter = 'latex';
        end

        if any(axe.XLabel.String == '$')
            axe.XLabel.Interpreter = 'latex';
        end

        if any(strjoin(axe.XTickLabel) == '$') || any(strjoin(axe.YTickLabel) == '$')
            axe.TickLabelInterpreter = 'latex';
        end

        if ~isempty(axe.Legend)
            if any(strjoin(axe.Legend.String) == '$')
                axe.Legend.Interpreter = 'latex';
            end
        end
    end
end

else
    for f = 1:nF
fig = sfigs(f);
axes = findall(fig.Children,'type','Axes');

axes.Legend.String = cellfun(@(x) erase(x,'$'),axes.Legend.String,'UniformOutput',false);
axes.XTickLabel = cellfun(@(x) erase(x,'$'),axes.XTickLabel,'UniformOutput',false);
axes.YTickLabel = cellfun(@(x) erase(x,'$'),axes.YTickLabel,'UniformOutput',false);
axes.XLabel.String = erase(axes.XLabel.String,'$');
axes.YLabel.String = erase(axes.YLabel.String,'$');

    end
end