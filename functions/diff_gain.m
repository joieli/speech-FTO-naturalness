function [audio_norm, t_new, G_dB, lag] = diff_gain(args)

    arguments
        args.audio (:, 2) double
        args.fs (1, 1) double
        args.nFilt (1, 1) double
        args.Gmax (1, 1) double
        args.Gmin (1, 1) double
        args.zpad (1, 1) double = 0
    end

    % Parse input arguments
    audio = args.audio;
    fs = args.fs;
    nFilt = args.nFilt;
    Gmax = args.Gmax;
    Gmin = args.Gmin;
    zpad = args.zpad;

    % Calculate lag between mics
    lag = 0; %mic_lags(audio = audio, n_max = 2 * fs);

    % Shift signals by computed lag
    n_pad = abs(lag) + zpad;
    t = (1:size(audio, 1)) / fs;
    y1 = [zeros(n_pad, 1); audio(:, 1); zeros(n_pad, 1)];
    y2 = [zeros(n_pad, 1); circshift(audio(:, 2), lag); zeros(n_pad, 1)];
    t_new = [-fliplr(1:n_pad) / fs t max(t) + (1:n_pad) / fs];

    idx_end = numel(t) + n_pad;
    idx_start = n_pad;

    % coeff = ones(1, nFilt) / nFilt;
    coeff = exp(-linspace(0, 5, nFilt));

    % coeff = triang(nFilt);
    coeff = coeff / sum(coeff);
    floor_lvl = -90;
    ceil_lvl = 0;

    y1_dB = max(mag2db(abs(y1)), floor_lvl);
    y1_dB_MA = filtfilt(coeff, 1, y1_dB);
    % y1_dB_MA = movmean(y1_dB, [0, nFilt - 1]);
    y1_dB_MA(idx_end:end) = floor_lvl;
    y1_dB_MA(1:idx_start) = ceil_lvl;

    y2_dB = max(mag2db(abs(y2)), floor_lvl);
    y2_dB_MA = filtfilt(coeff, 1, y2_dB);
    % y2_dB_MA = movmean(y2_dB, [0, nFilt - 1]);
    y2_dB_MA(idx_end:end) = ceil_lvl;
    y2_dB_MA(1:idx_start) = floor_lvl;

    G1_dB = max(min(y1_dB_MA - y2_dB_MA, Gmax), Gmin);
    G2_dB = max(min(y2_dB_MA - y1_dB_MA, Gmax), Gmin);
    G_dB = [G1_dB, G2_dB];

    G1 = db2mag(G1_dB);
    G2 = db2mag(G2_dB);

    audio_gained = [y1 .* G1, y2 .* G2];
    audio_norm = audio_gained / max(abs(audio_gained), [], 'all');

    %% Example use:
% n_pad = 2 * fs;
% Glim = [-40 0];
% [audio_gained, t_new, G, lag] = diff_gain(audio = audio, fs = fs, nFilt = 0.3 * fs, Gmax = Glim(2), Gmin = Glim(1), zpad = n_pad);
% 
% figure(3); clf;
% tiledlayout(2, 1)
% nexttile; plot(t_new, audio_gained(:, idx_first)); ylabel("Gained signal");
% yyaxis right; plot(t_new, G(:, idx_first)); ylabel("Gain (dB)"); ylim([Glim(1) - 1, Glim(2) + 1]); xlabel("Time (s)");
% nexttile; plot(t_new, audio_gained(:, idx_second)); ylabel("Gained signal");
% yyaxis right; plot(t_new, G(:, idx_second)); ylabel("Gain (dB)"); ylim([Glim(1) - 1, Glim(2) + 1]); xlabel("Time (s)");