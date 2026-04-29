resultspath = "results";
audiopath = "audio_clips";
clipNames = [
    "F1F2_quiet_food_clip01"; % train
    "F1F2_quiet_food_clip05"; % train
    "F1F2_quiet_food_clip07";
    "F1F2_quiet_food_clip08";
    "F1F2_quiet_food_clip11"; 
    "F1F2_quiet_food_clip13"; 
    "F1F2_quiet_food_clip14"; 
    "F1F2_quiet_food_clip17"; % train

    "F1M1_quiet_games_clip01";
    "F1M1_quiet_games_clip04";
    "F1M1_quiet_games_clip05";
    "F1M1_quiet_games_clip06";
    "F1M1_quiet_games_clip07"; % train
    "F1M1_quiet_games_clip08";

    "F2M1_quiet_birthday_clip01";
    "F2M1_quiet_birthday_clip02";
    "F2M1_quiet_birthday_clip03";
    "F2M1_quiet_birthday_clip05";
    "F2M1_quiet_birthday_clip06";
    "F2M1_quiet_birthday_clip07";
    ];

n_clips = length(clipNames);
base_offsets = zeros(n_clips,1);
clips(n_clips) = AudioClip; 

for clipIdx = 1:n_clips
    clips(clipIdx) = load_audio_clip(audiopath, clipNames(clipIdx), true);
    base_offsets(clipIdx) = round(getBaseOffset(audiopath,clipNames(clipIdx)));
    clips(clipIdx).base_offset = base_offsets(clipIdx);
end
