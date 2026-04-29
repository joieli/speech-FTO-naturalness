for trainIdx = 1:n_trainClips
    pause(0.75);
    disp(trainNames(trainIdx))
    playShiftedAudio(trainClips(trainIdx), train_rel_offsets(trainIdx,size(rel_offsets,2)), true);
    pause(0.75);
end

for clipIdx = 1:n_clips
    pause(0.75);
    disp(clipNames(clipIdx))
    playShiftedAudio(clips(clipIdx), rel_offsets(clipIdx,size(rel_offsets,2)), true);
    pause(0.75);
end