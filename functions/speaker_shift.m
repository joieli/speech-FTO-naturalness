function [y_tot, y1, y2, t_new] = speaker_shift(audio, fs, t_shift) %in seconds

    arguments
        audio (:, 2) double
        fs (1, 1) double {mustBePositive}
        t_shift (1, 1) double {mustBeReal} = 0 %in seconds
    end

    % Pad samples according to desired shift
    n_pad = ceil(abs(t_shift * fs)) + 1 + 2*fs; %pad by an additional fs samples so I get one second of sielence before and after

    % Pad audio signals
    y1_pad = [zeros(n_pad, 1); audio(:, 1); zeros(n_pad, 1)];
    y2_pad = [zeros(n_pad, 1); audio(:, 2); zeros(n_pad, 1)];

    % Shift audio signals
    audio_combined = [y1_pad circshift(y2_pad, t_shift * fs)];
    idx_start = 1;
    idx_end = size(audio_combined, 1);

    % Return separated and combined signals
    y1 = audio_combined(:, 1);
    y2 = audio_combined(:, 2);
    y_tot = audio_combined;

    % New time vector
    t = (1:size(audio, 1)) / fs;
    t_new = [(-fliplr(1:n_pad) / fs) t (max(t) + (1:n_pad) / fs)];

    % Remove trailing and leading zeros, leaving a little for noise
    y_sum = sum(audio_combined, 2);
    idx = find(y_sum, 1, 'first')-fs-randi([0,floor(fs/2)]): find(y_sum, 1, 'last')+fs/4; %add some jitter to the front
    y1 = y1(idx);
    y2 = y2(idx);
    y_tot = y_tot(idx,:);
    t_new = t_new(idx);

end
