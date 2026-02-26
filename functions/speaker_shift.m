function [y_tot, y1, y2 t_new] = speaker_shift(audio, fs, t_shift)

    arguments
        audio (:, 2) double
        fs (1, 1) double {mustBePositive}
        t_shift (1, 1) double {mustBeReal} = 0
    end

    % Pad samples according to desired shift
    n_pad = ceil(abs(t_shift * fs)) + 1;

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
    y_tot = sum(audio_combined, 2);

    % New time vector
    t = (1:size(audio, 1)) / fs;
    t_new = [(-fliplr(1:n_pad) / fs) t (max(t) + (1:n_pad) / fs)];

end
