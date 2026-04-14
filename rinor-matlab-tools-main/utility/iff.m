function x = iff(cond,val,alt)

if numel(val)==1 && numel(alt) > 1
    val = repmat(val,size(alt));
    cond = repmat(cond,size(alt));
elseif numel(alt) == 1 && numel(val) > 1
    alt = repmat(alt,size(val));
    cond = repmat(cond,size(val));
end

assert(all(size(val) == size(alt)))

x = nan(size(val));
for i = 1:numel(val)
    if cond(i)
        x(i) = val(i);
    else
        x(i) = alt(i);
    end
end
end