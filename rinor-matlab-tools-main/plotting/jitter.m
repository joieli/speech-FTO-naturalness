function xj = jitter(x, k)

    if ~exist('k', 'var')
        k = 1;
    end

    % xbar = median(x);
    xj = x + k .* (rand(size(x, 1), 1) - 0.5);
