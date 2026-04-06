function updateResponseGUI(gui, mode, trialLabel)

    % Optional trial label update
    if nargin >= 3 && ~isempty(trialLabel)
        gui.trialText.String = trialLabel;
    end

    switch lower(mode)

        case 'start'
            gui.questionText.String = ...
                'Press any key or button to start the experiment';
            gui.questionText.FontSize = 16;
        
            set(gui.yesButton,'Enable','on');
            set(gui.noButton,'Enable','on');

            % remove focus
        
            setappdata(gui.fig,'mode','start');
        
        case 'disable'
            gui.questionText.String = ...
                'Experiment complete. Press any key or button to end';
            gui.questionText.FontSize = 16;

            % Disable buttons to remove focus
            set(gui.yesButton, 'Enable', 'off');
            set(gui.noButton,  'Enable', 'off');

            % remove focus
            setappdata(gui.fig,'mode','end');
        
        
        case 'end'
            gui.questionText.String = ...
                'Experiment complete. Press any key or button to end';
            gui.questionText.FontSize = 16;

            % reneable buttons
            set(gui.yesButton,'Enable','on');
            set(gui.noButton,'Enable','on');

            % remove focus
            setappdata(gui.fig,'mode','end');
        
        case 'playing'
            % Change question text
            gui.questionText.String = 'Audio playing...';
            gui.questionText.FontSize = 16;

            % Disable buttons while audio is playing
            set(gui.yesButton, 'Enable', 'off');
            set(gui.noButton,  'Enable', 'off');

            setappdata(gui.fig,'mode','playing');

        case 'question'
            % Restore question
            gui.questionText.String = ...
                'Did the pause between the speakers sound natural?';
            gui.questionText.FontSize = 14;

            % Enable buttons after audio
            set(gui.yesButton, 'Enable', 'on');
            set(gui.noButton,  'Enable', 'on');

            setappdata(gui.fig,'mode','question');

        otherwise
            error('Unknown GUI mode: %s', mode);
    end

    drawnow;
end