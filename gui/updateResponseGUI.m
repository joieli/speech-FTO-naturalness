function updateResponseGUI(gui, mode, trialLabel)

    % Optional trial label update
    if nargin >= 3 && ~isempty(trialLabel)
        gui.trialText.String = trialLabel;
    end

    switch lower(mode)

        case 'start'
            gui.questionText.String = {
                'Adjust your volume while listening to the white noise.'
                ''
                'Press 1 or 0 to begin'
            };
            gui.questionText.FontSize = 16;
        
            set(gui.yesButton,'Enable','on');
            set(gui.noButton,'Enable','on');

            % remove focus
        
            setappdata(gui.fig,'mode','start');
        
        case 'break'
            gui.questionText.String = {
                'Break.'
                ''
                'Press 1 or 0 to continue'
            };
            gui.questionText.FontSize = 16;
        
            set(gui.yesButton,'Enable','on');
            set(gui.noButton,'Enable','on');
        
            setappdata(gui.fig,'mode','break');
        
        case 'end'
            gui.questionText.String = {
                'Experiment complete.'
                ''
                'Press 1 or 0 to end'
            };
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
                'Did the pause between the speakers sound NATURAL or UNNATURAL in length (not too long and not too short)?';
            gui.questionText.FontSize = 14;

            % Enable buttons after audio
            set(gui.yesButton, 'Enable', 'on');
            set(gui.noButton,  'Enable', 'on');

            setappdata(gui.fig,'mode','question');

        
        case 'disable'
            gui.questionText.String = ...
                '-';
            gui.questionText.FontSize = 16;

            % Disable buttons to remove focus
            set(gui.yesButton, 'Enable', 'off');
            set(gui.noButton,  'Enable', 'off');

            % remove focus
            setappdata(gui.fig,'mode','end');

        otherwise
            error('Unknown GUI mode: %s', mode);
    end

    drawnow;
end