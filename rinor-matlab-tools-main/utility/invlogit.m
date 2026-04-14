function y = invlogit(x)
%%% Inverse logit function (converts log-odds to probabilities).
arguments
    % Input values in log-odds scale
    x double
end

y = 1 ./ (1 + exp(-x));
