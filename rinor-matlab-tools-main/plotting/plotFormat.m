function plotFormat(scale,figs,printFolder)
% TO DO: format-dependent scaling
arguments
    scale double = 1
    figs = findobj('Type','figure');
    printFolder = nan;
end

if isempty(scale)
    scale = 1;
end
if isempty(figs)
    figs = findobj('Type','figure');
end

latexFormat(figs);

nF = numel(figs);
[~,sidx] = sort([figs.Number]);
sfigs = figs(sidx);

baseFS = 11;

for f = 1:nF
    fig = sfigs(f);
    set(fig,'renderer','painters')
    axes = findall(fig.Children,'type','Axes');
    nAx = numel(axes);

    for ax = 1:nAx
        axe = axes(ax);
        axe.FontSize = baseFS*scale;
        try axe.Legend.FontSize = baseFS*scale*0.75; end
    end

    if ischar(printFolder)
            print(fig,'-vector','-dsvg',[printFolder fig.Name]);
    end

    fig.Position(3) = fig.Position(3);
    fig.Position(4) = fig.Position(4);

    for ax = 1:nAx
        axe = axes(ax);
        axe.FontSize = axe.FontSize;
    end
end
