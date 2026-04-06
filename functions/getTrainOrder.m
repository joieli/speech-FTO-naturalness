function order = getTrainOrder(n_clips, n_offsets, train_reps_per_clip)
    order = zeros(1, n_clips*train_reps_per_clip);
    order(1:n_clips) = randperm(n_clips);
    last_clip = order(n_clips); %save last clip to compare to first to make sure no overlap

    % define the clip order
    for rep = 2:train_reps_per_clip
        segment = randperm(n_clips);
        attempts = 0;
        while segment(1) == last_clip
            attempts = attempts + 1;
            if attempts > factorial(n_clips)*2
                error("Too many attempts in creating training clip order")
            end
            segment = randperm(n_clips);
        end
        last_clip = segment(end);
        order((rep-1)*n_clips+1:rep*n_clips) = segment;
    end

    %choose which offset to use
    for idx = 1:numel(order)
        order(idx) = order(idx) + randi([0,n_offsets-1])*n_clips;
    end
end