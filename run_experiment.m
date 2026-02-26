%% What files to look into for reference
% Signal Processing SDT: afc_main in
% C:\Users\joiel\OneDrive\Documents\22003 SIgnal Processing\02_SDT\SDT
% win\afc\base for making the pop-up
% 



%% Parameters
audiopath = "audio_clips";
clipNames = ["F1F2_quiet_food_clip01"];     % audio clips to use
max_min_offset = [-500, 500];               % minimum and maximum offset in ms
n_offsets = 10;                           % how many different offsets to test
reps_per_offset_per_clip = 5;                        % how many repetitions of each offset to present the participant                        

n_clips = length(clipNames);
n_trials = n_clips*n_offsets*reps_per_offset_per_clip;

%% How data is stored
% Stored in trial object
% trial.idx
% trial.clipIdx | trial.clipName
% trial.offsetIdx | trial.relOffset | tral.absOffsets
% trial.repIdx

%%

% create table to store data
raw_results_table = zeros(n_clips,n_offsets,reps_per_offset_per_clip);      %access with raw_results_table(clip_idx, offset_idx,rep_idx)
raw_results_time(n_trials) = Trial;                                         %access with raw_results_time(idx).property
rel_offsets = linspace(max_min_offset(1), max_min_offset(2),n_offsets);     %acesss with relative_offsets(offset_idx)
abs_offsets = zeros(n_clips,n_offsets);                                     %access with absolute_offsets(clip_idx, offset_idx) 

[t, audio, fs, idx_first, idx_second] = load_audio_clip(audiopath, clipNames(1), true);



%%
% Play full audio signal (L/R split)
soundsc(audio, fs)
pause(max(t) + 1)