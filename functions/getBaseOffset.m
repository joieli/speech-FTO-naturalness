function base_offset = getBaseOffset(audiopath, audio_clip_name)
    %returns the base_offset in ms

    % load text file
    audio_clip_txt_file = fullfile(audiopath, audio_clip_name+"_labels_manual_rinor.txt");
    if ~isfile(audio_clip_txt_file)
        error('Manual labels do not exist: %s', audio_clip_txt_file);
    end

    %load table
    opts = detectImportOptions(audio_clip_txt_file);
    opts.VariableTypes = {'string','string','double','double','double','string'};

    T = readtable(audio_clip_txt_file, opts);
    T.Properties.VariableNames = {'talker', 'foo', 'onset_time', 'offset_time', 'duration', 'type'};

    % Find index of first talker (earliest onset)
    [~, idx_first] = min(T.onset_time);
    
    % Index of the other talker
    idx_second = 3 - idx_first; %NOTE: only works if there are only 2 entries in the .txt, one for each talker
    
    % Floor transfer time
    base_offset = T.onset_time(idx_second) - T.offset_time(idx_first);
    base_offset = round(base_offset*1000);
end