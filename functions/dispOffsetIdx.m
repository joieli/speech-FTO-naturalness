function dispOffsetIdx(train_order, raw_results_table)
    offsets=zeros(numel(train_order),1);
    for idx = 1:numel(train_order)
        clip=train_order(idx);
        [~,offsets(idx),~] = ind2sub(size(raw_results_table),clip);
    end
    disp(offsets)
end