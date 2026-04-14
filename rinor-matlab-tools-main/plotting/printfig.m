function printfig(figs,printpath,type,printFlag)
arguments
    figs handle = []
    printpath char = ''
    type char = 'svg'
    printFlag logical = true
end

if isempty(figs)
    figs = findobj('Type','figure');
end
nF = numel(figs);
[~,sidx] = sort([figs.Number]);
sfigs = figs(sidx);

if all(cellfun(@(x) ~isempty(x),{figs.Name}))
    for f = 1:nF
        outfilename{f} = [printpath figs(sidx(f)).Name];
    end
else
    error("Set figure name using set(gcf(),'Name','foo')")
end

if printFlag
    for f = 1:nF
        fig = sfigs(f);

        axes = findall(fig.Children,'type','Axes');
        nAx = numel(axes);
        for a = 1:nAx
            set(axes(a), 'units', 'normalized'); %Just making sure it's normalized
            Tight = get(axes(a), 'TightInset');  %Gives you the bording spacing between plot box and any axis labels
            %[Left Bottom Right Top] spacing
            NewPos = [Tight(1)*1.04 Tight(2)*1.04 (1-Tight(1)-Tight(3))*0.98 (1-Tight(2)-Tight(4))*0.98]; %New plot position [X Y W H]
            set(axes(a), 'Position', NewPos);
        end

        switch type
            case 'pdf'
                set(fig, 'PaperUnits','centimeters');
                set(fig, 'Units','centimeters');
                pos=get(fig,'Position');
                set(fig, 'PaperSize', [pos(3) pos(4)]);
                set(fig, 'PaperPositionMode', 'manual');
                set(fig, 'PaperPosition',[0 0 pos(3) pos(4)]);
                print(fig, '-image', '-r1116', '-dpdf', outfilename{f})

            case 'svg'
                set(fig, 'PaperUnits','centimeters');
                set(fig, 'Units','centimeters');
                pos=get(fig,'Position');
                set(fig, 'PaperSize', [pos(3) pos(4)]);
                set(fig, 'PaperPositionMode', 'manual');
                set(fig, 'PaperPosition',[0 0 pos(3) pos(4)]);
                set(fig,"Renderer","painters")
                print(fig, outfilename{f}, '-dsvg')

            case 'eps'
                set(fig,"Renderer","painters")
                print(fig, outfilename{f}, '-deps')

        end
    end
end