function lgc = unfind(idx)
    %Go from indicies into logical (for vectors only)
    M = max(idx);
    N = numel(idx);
    lgc = false(N,M);
    for n = 1:N
    lgc(n,idx(n)) = true;
    end
end