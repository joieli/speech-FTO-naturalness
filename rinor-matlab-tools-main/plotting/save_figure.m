function save_figure(figno, save_folder)
    %%% Save current figure as PNG file.
    arguments
        % Figure number (used in filename)
        figno (1, 1) double

        % Output folder path
        save_folder (1, 1) string = "figures"
    end

    % Create output directory if it doesn't exist
    output_dir = fullfile(pwd, save_folder);

    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    % Export figure as PNG
    output_file = fullfile(output_dir, sprintf('figure_%d.png', figno));
    exportgraphics(gcf, output_file, 'Resolution', 300);

end
