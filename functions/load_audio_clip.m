function clip = load_audio_clip(audiopath, audio_clip_name, manual_gating)
    %COMPUTE_SPEAKER_GAIN Summary of this function goes here
    %   Detailed explanation goes here

    % Load audio clip
    audiofile_clip = fullfile(audiopath, audio_clip_name+".wav");
    [audio_clip_raw, fs] = audioread(audiofile_clip);
    t = (1:size(audio_clip_raw, 1)) / fs;

    if ~max(audio_clip_raw(:) == 1)
        audio_clip_raw = audio_clip_raw / max(abs(audio_clip_raw(:)));
        audiowrite(audiofile_clip, audio_clip_raw, fs);
    end

    % Load manual labels and decode turns
    audio_clip_txt_file = fullfile(audiopath, audio_clip_name+"_labels_manual_rinor.txt");
    if ~isfile(audio_clip_txt_file)
        error('Manual labels do not exist: %s', audio_clip_txt_file);
    end

    opts = detectImportOptions(audio_clip_txt_file);
    opts.VariableTypes = {'string','string','double','double','double','string'};

    T = readtable(audio_clip_txt_file, opts);
    T.Properties.VariableNames = {'talker', 'foo', 'onset_time', 'offset_time', 'duration', 'type'};
    T.onset_sample = round(T.onset_time * fs) + 1;
    T.offset_sample = round(T.offset_time * fs) + 1;
    z = decode_turns(T, length(audio_clip_raw));

    % Compute speaker gain to equalize levels
    rms_values = zeros(1, 2);

    for i = 1:2
        speaker_signal = audio_clip_raw(:, i) .* z(:, i);
        speaker_signal = speaker_signal(speaker_signal ~= 0); % Remove zeros
        rms_values(i) = rms(speaker_signal);
    end

    % Placeholder for actual gain computation logic
    gain = 1 ./ rms_values; % Example: inverse of RMS as gain

    audio(:, 1) = gain(1) * audio_clip_raw(:, 1);
    audio(:, 2) = gain(2) * audio_clip_raw(:, 2);

    if manual_gating
        audio(:, 1) = audio(:, 1) .* z(:, 1);
        audio(:, 2) = audio(:, 2) .* z(:, 2);
    end

    % Determine speaker order (based on energy in first half of signal)
    tot_energy = sum(audio(1:ceil(end / 2), :) .^ 2);
    [~, idx_first] = max(tot_energy);
    idx_second = 3 - idx_first; % If first is 1, second is 2 and vice versa

    clip = AudioClip(t, audio, fs, idx_first, idx_second);
end
