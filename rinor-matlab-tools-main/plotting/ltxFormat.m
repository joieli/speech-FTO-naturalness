function ltxFormat(scale,type,figs)

arguments
    scale double = 1;
    type char = 'article'
    figs = findobj('Type','figure');
end

if isempty(figs)
    figs = findobj('Type','figure');
end
nF = numel(figs);
[~,sidx] = sort([figs.Number]);
sfigs = figs(sidx);

for f = 1:nF
    fig = sfigs(f);
    axes = findall(fig.Children,'type','Axes');
    nAx = numel(axes);
    [TitFS, AxeFS, LabFS, LegFS] = plotFontSizes(type,scale);

    for ax = 1:nAx
        axe = axes(ax);
        axe.XTick = axe.XTick;
        axe.YTick = axe.YTick;
        axe.ZTick = axe.ZTick;

        axe.FontSize = AxeFS;
        axe.Title.FontSize = TitFS;
        axe.XLabel.FontSize = LabFS;
        axe.YLabel.FontSize = LabFS;
        axe.ZLabel.FontSize = LabFS;
        try axe.Legend.FontSize = LegFS; end


        switch type
            case 'article'
                axe.YLabel.Interpreter = 'latex';
                axe.XLabel.Interpreter = 'latex';
                axe.ZLabel.Interpreter = 'latex';
                axe.TickLabelInterpreter = 'latex';
                try axe.Legend.Interpreter = 'latex'; end
                axe.Title.Interpreter = 'latex';

                % Remove '\' from previous calls to function
                try axe.Title.String = strrep(axe.Title.String,'\%','%'); end
                try axe.Legend.String = cellfun(@(x) strrep(x,'\%','%'),axe.Legend.String,'UniformOutput',false); end
                try axe.XTickLabel = cellfun(@(x) strrep(x,'\%','%'),axe.XTickLabel,'UniformOutput',false); end
                try axe.YTickLabel = cellfun(@(x) strrep(x,'\%','%'),axe.YTickLabel,'UniformOutput',false); end
                try axe.ZTickLabel = cellfun(@(x) strrep(x,'\%','%'),axe.ZTickLabel,'UniformOutput',false); end

                axe.XLabel.String = strrep(axe.XLabel.String,'\%','%');
                axe.YLabel.String = strrep(axe.YLabel.String,'\%','%');
                axe.ZLabel.String = strrep(axe.ZLabel.String,'\%','%');

                % Add '\' to every '%'
                try axe.Title.String = strrep(axe.Title.String,'%','\%'); end
                try axe.Legend.String = cellfun(@(x) strrep(x,'%','\%'),axe.Legend.String,'UniformOutput',false); end
                try axe.XTickLabel = cellfun(@(x) strrep(x,'%','\%'),axe.XTickLabel,'UniformOutput',false); end
                try axe.YTickLabel = cellfun(@(x) strrep(x,'%','\%'),axe.YTickLabel,'UniformOutput',false); end
                try axe.ZTickLabel = cellfun(@(x) strrep(x,'%','\%'),axe.ZTickLabel,'UniformOutput',false); end

                axe.XLabel.String = strrep(axe.XLabel.String,'%','\%');
                axe.YLabel.String = strrep(axe.YLabel.String,'%','\%');
                axe.ZLabel.String = strrep(axe.ZLabel.String,'%','\%');

            case {'poster','presentation'}
                axe.YLabel.Interpreter = 'tex';
                axe.XLabel.Interpreter = 'tex';
                axe.ZLabel.Interpreter = 'tex';
                axe.TickLabelInterpreter = 'tex';
                try axe.Legend.Interpreter = 'tex'; end
                axe.Title.Interpreter = 'tex';
                try axe.Title.String = strrep(axe.Title.String,'$',''); end
                try axe.Legend.String = cellfun(@(x) strrep(x,'$',''),axe.Legend.String,'UniformOutput',false); end
                try axe.XTickLabel = cellfun(@(x) strrep(x,'$',''),axe.XTickLabel,'UniformOutput',false); end
                try axe.YTickLabel = cellfun(@(x) strrep(x,'$',''),axe.YTickLabel,'UniformOutput',false); end
                try axe.ZTickLabel = cellfun(@(x) strrep(x,'$',''),axe.ZTickLabel,'UniformOutput',false); end

                axe.XLabel.String = strrep(axe.XLabel.String,'$','');
                axe.YLabel.String = strrep(axe.YLabel.String,'$','');
                axe.ZLabel.String = strrep(axe.ZLabel.String,'$','');

        end
    end

end
