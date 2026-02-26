function s = decode_turns(T, signal_length)
    %%% Reconstruct binary time series from onset/offset table.
    %   This is the inverse of encode_turns.

    arguments
        % Table from encode_turns with columns: talker, onset_sample, offset_sample
        T table

        % Total number of samples in the original signal
        signal_length (1, 1) double
    end

    talkers = unique(T.talker);
    n_talkers = numel(talkers);

    % Initialize output as all zeros
    s = zeros(signal_length, n_talkers);

    % Fill in the ones for each onset-offset pair
    for i = 1:height(T)
        talker = T.talker(i);
        onset = T.onset_sample(i);
        offset = T.offset_sample(i);
        s(onset:offset - 1, talkers == talker) = 1;
    end

end
