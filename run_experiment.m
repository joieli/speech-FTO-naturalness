%% What files to look into for reference
% Signal Processing SDT: afc_main in
% C:\Users\joiel\OneDrive\Documents\22003 SIgnal Processing\02_SDT\SDT
% win\afc\base for making the pop-up
% 
rng(42);


%% Parameters
audiopath = "audio_clips";
clipNames = ["F1F2_quiet_food_clip01", "F1F2_quiet_food_clip02"];     % audio clips to use
max_min_offset = [-500, 500];               % minimum and maximum offset in ms
n_offsets = 3;                           % how many different offsets to test
reps_per_offset_per_clip = 4;                        % how many repetitions of each offset to present the participant                        

n_clips = length(clipNames);
n_trials = n_clips*n_offsets*reps_per_offset_per_clip;

%%

% create table to store audio clips
clips(n_clips) = AudioClip;                                                 %access with clips(clipIdx)
rel_offsets = linspace(max_min_offset(1), max_min_offset(2),n_offsets);     %acesss with relative_offsets(offsetIdx)
abs_offsets = zeros(n_clips,n_offsets);                                     %access with absolute_offsets(clipIdx, offsetIdx) 

% create tables to store data
raw_results_table = zeros(n_clips,n_offsets,reps_per_offset_per_clip);      %access with raw_results_table(clipIdx, offsetIdx,repIdx)
raw_results_time(n_trials) = Trial;                                         %access with raw_results_time(idx).property

%% Load audios
for clipIdx = 1:n_clips
    clips(clipIdx) = load_audio_clip(audiopath, clipNames(clipIdx), true);
    base_offset = clipIdx; % ToDo: Fix Me, how to determine this??
    abs_offsets(clipIdx, :) = rel_offsets + base_offset;
end

%% Go through the clips
clip_order = randperm(n_trials);
for idx = 1:n_trials
    % populate the trial data
    clip_number = clip_order(idx);  %which clip parameters are we using
    [clipIdx,offsetIdx, repIdx] = ind2sub(size(raw_results_table),clip_number); % where is the clip located in the table
    raw_results_time(idx).clipIdx = clipIdx;
    raw_results_time(idx).clipName = clipNames(clipIdx);
    raw_results_time(idx).offsetIdx = offsetIdx;
    raw_results_time(idx).relOffset = rel_offsets(offsetIdx);
    raw_results_time(idx).absOffset = abs_offsets(clipIdx, offsetIdx);
    raw_results_time(idx).repIdx = repIdx;

    % ToDo: play the clip

    % ToDo: Gather response

    % ToDo: Log response
    raw_results_time(idx).soundsNatural = 100+idx; % ToDo: true or false
    raw_results_table(clipIdx,offsetIdx, repIdx) = 100+idx; %ToDo:true or false
end 



%%
% Play full audio signal (L/R split)
%soundsc(clips(2).audio, clips(2).fs)
%pause(max(clips(2).t) + 1)