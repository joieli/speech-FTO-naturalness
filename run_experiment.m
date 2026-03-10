%% What files to look into for reference
% Signal Processing SDT: afc_main in
% C:\Users\joiel\OneDrive\Documents\22003 SIgnal Processing\02_SDT\SDT
% win\afc\base for making the pop-up


% function run_experiment(participant_initials, participant_ID)
%     putCodeHere!!
% end

%Temp: Placeholders for the parameterse that need to be passed to the
%function
clear; clc; close all;
participant_initials = "test";
participant_ID = "subject01";


%% Parameters
rng(42);
audiopath = "audio_clips";
clipNames = ["F1F2_quiet_food_clip01","F1F2_quiet_food_clip06","F1F2_quiet_food_clip09"];     % audio clips to use, access with clipNames(clipIdx)
resultspath = "results";
rel_offsets = [0];  %relative_offsets in ms, acesss with relative_offsets(offsetIdx)
reps_per_offset_per_clip = 1;                          % how many repetitions of each offset to present the participant                        
timeMe = false;

%Create subject string
fileBase = string(datetime('now'),'yyyyMMdd_HH_mm_ss') + "__" + participant_ID;

%Create entry in participant_key 
keyPath = fullfile(resultspath, "participant_key.txt");
file = fopen(keyPath, 'a+');
fprintf(file, sprintf('%s \t \t %s \n', participant_initials, fileBase));
fclose(file);

n_offsets = length(rel_offsets);
n_clips = length(clipNames);
n_trials = n_clips*n_offsets*reps_per_offset_per_clip;

%% Creating placeholders to store data
% create table to store audio clips
clips(n_clips) = AudioClip;                                                 %access with clips(clipIdx).property
abs_offsets = zeros(n_clips,n_offsets);                                     %access with absolute_offsets(clipIdx, offsetIdx) 

% create tables to store data
raw_results_table = zeros(n_clips,n_offsets,reps_per_offset_per_clip);      %access with raw_results_table(clipIdx, offsetIdx,repIdx) - each table is a repetition, each row is a clip, each col is a different offset
raw_results_time(n_trials) = Trial;                                         %access with raw_results_time(idx).property

%% Load audios
for clipIdx = 1:n_clips
    clips(clipIdx) = load_audio_clip(audiopath, clipNames(clipIdx), true);
    base_offset = getBaseOffset(audiopath,clipNames(clipIdx));
    abs_offsets(clipIdx, :) = rel_offsets + base_offset;
end

%% Experiment Begin - Go through the clips
if timeMe
    tic;
end
fprintf("EXPERIMENT BEGINS: %s \n", fileBase);

clip_order = randperm(n_trials);
for idx = 1:n_trials
    fprintf("Trial: %d/%d \n",idx, n_trials);

    % populate the trial data
    clip_number = clip_order(idx);  %which clip parameters are we using
    [clipIdx,offsetIdx, repIdx] = ind2sub(size(raw_results_table),clip_number); % where is the clip located in the table
    raw_results_time(idx).clipIdx = clipIdx;
    raw_results_time(idx).clipName = clipNames(clipIdx);
    raw_results_time(idx).offsetIdx = offsetIdx;
    raw_results_time(idx).relOffset = rel_offsets(offsetIdx);
    raw_results_time(idx).absOffset = abs_offsets(clipIdx, offsetIdx);
    raw_results_time(idx).repIdx = repIdx;

    % play the clip
    pause(1);
    playShiftedAudio(clips(clipIdx), rel_offsets(offsetIdx), true);

    % ToDo: Gather response - Change to a graphical interface
    pause(1);
    prompt = "Did the gap between the speakers sound natural? Answer 1 for yes. Answer 0 for no. \nAnswer: ";
    response = input(prompt);
    disp("   ");

    %Log response
    raw_results_time(idx).soundsNatural = response;
    raw_results_table(clipIdx,offsetIdx, repIdx) = response;
end 

%%
disp("EXPERIMENT DONE!")
disp("     ")
if timeMe
    toc;
end

%% Post Stuff

%% Basic Process
%ToDo: Calculate average naturalness per clip per offset

%% Save the data into a .mat file
dataFile = fullfile(resultspath,fileBase + ".mat");
save(dataFile, "rel_offsets","abs_offsets","raw_results_time", "raw_results_table");
fprintf("Data saved into: %s \n", dataFile);

