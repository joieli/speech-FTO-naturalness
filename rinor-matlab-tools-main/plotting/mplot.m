function mplot(fig, name, opts)
%%% Format and save a figure using project conventions.
% Applies plotFormat, sets the figure name, and saves as SVG via printfig.
arguments
    % Handle to the figure to format and save
    fig (1, 1) matlab.ui.Figure

    % Short, informative figure name (used as SVG filename)
    name (1, 1) string

    % Output folder for saved figures
    opts.print_folder (1, 1) string = "figures/"

    % Font scale passed to plotFormat
    opts.scale (1, 1) double = 1
end

plotFormat(opts.scale, fig);
set(fig, 'Name', name);
printfig(fig, opts.print_folder, 'svg');

end
