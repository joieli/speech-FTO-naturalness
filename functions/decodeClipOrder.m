function clipIdx = decodeClipOrder(table, clip_number)
    [clipIdx,~, ~] = ind2sub(size(table),clip_number); % where is the clip located in the table
end