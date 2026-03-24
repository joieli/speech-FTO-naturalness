function order = getpRandClipOrder(n_clips, n_offsets, reps_per_offset_per_clip)
    % if indexing raw_results_table linearly, all indexes with the same
    % modulo are the same clip --> Make it so following clips do not have
    % the same modulo

    n_trials = n_clips*n_offsets*reps_per_offset_per_clip;
    if n_clips == 1
        order = randperm(n_trials);
    else
        order = zeros(1,n_trials-1);
        bag = 1:n_trials;
    
        % randomly select a trial from a bag
        bag_idx = randi(n_trials,1);
        order(1) = bag(bag_idx);                % push that trial into the order
        prevClip = mod(bag(bag_idx),n_clips);   % save the clipNumber
        bag(bag_idx) = [];                      % remove trial from the bag
    
        % fill up the order
        for i = 2:n_trials
            bag_size = length(bag);
            
            % get another trial from the bag
            bag_idx = randi(bag_size,1);
            curClip = mod(bag(bag_idx),n_clips);        % check the clipNumber
            attempts = 0;
            
            while curClip == prevClip
                attempts = attempts + 1;
                if attempts > 10
                    break;
                end
                bag_idx = randi(bag_size,1);            % try again
                curClip = mod(bag(bag_idx),n_clips);    % check the clipNumber
            end
            
            if attempts > 10
               break;
            end
    
            order(i) = bag(bag_idx);                % add that trial into the order
            prevClip = curClip;                     % update prevClip
            bag(bag_idx) = [];                      % remove trial from the bag
        end
    
        
        for i = 1:length(bag)                       % going through whatever is remaning in the bag to find it a slot
            clip = mod(bag(1),n_clips);             % check the first number remaining in the bag
            
            bag_size = length(bag);
            % dealing with the last clip in the bag
            while length(bag) == bag_size     %until we find a slot for this element
                clip_idx = randi(n_trials-2,1);
                prevClip = mod(order(clip_idx),n_clips);     
                nextClip = mod(order(clip_idx+1),n_clips);
        
                if prevClip ~= clip && nextClip ~= clip
                    order = [order(1:clip_idx) bag(1) order(clip_idx+1:end)];
                    bag(1) = [];        % get rid of that trial in the bag
                end
            end
        end
    end
end