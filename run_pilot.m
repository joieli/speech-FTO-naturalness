%% THIS IS THE PILOT

%% What files to look into for reference

% Signal Processing SDT: afc_main in
% C:\Users\joiel\OneDrive\Documents\22003 SIgnal Processing\02_SDT\SDT
% win\afc\base for making the pop-up


% function run_pilot(participant_initials, participant_ID)
%     putCodeHere!!
% end


%Temp: Placeholders for the parameterse that need to be passed to the
%function
clear; clc; close all;
participant_initials = "test";
participant_ID = "subject01";


%% Parameters
rng(42);
%paths
audiopath = "audio_clips";
clipNames = ["F1F2_quiet_food_clip01","F1F2_quiet_food_clip05","F1F2_quiet_food_clip07","F1F2_quiet_food_clip08"...
    ,"F1F2_quiet_food_clip11", "F1F2_quiet_food_clip13", "F1F2_quiet_food_clip14", "F1F2_quiet_food_clip17"];     % audio clips to use, access with clipNames(clipIdx)
resultspath = "results";
%parameters
abs_offsets = [0,2000];             %absolute_offsets in ms, acesss with abs_offsets(offsetIdx)
reps_per_offset_per_clip = 1;                                       % how many repetitions of each offset to present the participant                        
timeMe = true;
%training
runTrain = true;
train_reps_per_clip = 2;

%Create subject string
fileBase = string(datetime('now'),'yyyyMMdd_HH_mm_ss') + "__" + participant_ID;

n_offsets = length(abs_offsets);
n_clips = length(clipNames);
n_trials = n_clips*n_offsets*reps_per_offset_per_clip;

%% Creating placeholders to store data
% create table to store audio clips and data
clips(n_clips) = AudioClip;                                                 %access with clips(clipIdx).property
base_offsets = zeros(n_clips,1);                                               %access with base_offsets(clipIdx)
rel_offsets = zeros(n_clips,n_offsets);                                     %access with rel_offsets(clipIdx, offsetIdx) 


% create tables to store data
raw_results_table = zeros(n_clips,n_offsets,reps_per_offset_per_clip);      %access with raw_results_table(clipIdx, offsetIdx,repIdx) - each table is a repetition, each row is a clip, each col is a different offset
raw_results_time(n_trials) = Trial;                                         %access with raw_results_time(idx).property

%% Load audios
for clipIdx = 1:n_clips
    clips(clipIdx) = load_audio_clip(audiopath, clipNames(clipIdx), true);
    base_offsets(clipIdx) = getBaseOffset(audiopath,clipNames(clipIdx));
    clips(clipIdx).base_offset = base_offsets(clipIdx);
    rel_offsets(clipIdx, :) = abs_offsets-base_offsets(clipIdx);
end

%% get clip order
clip_order = getpRandClipOrder(n_clips, n_offsets, reps_per_offset_per_clip);

%% Experiment Begin - Go through the clips
if timeMe
    tic;
end

% Running two training trials
n_train = 0;
if runTrain == true
    fprintf("PILOT BEGINS: %s \n", fileBase);
    n_train = n_clips*train_reps_per_clip;
    % ToDo:
end


for idx = 1:n_trials
    fprintf("Trial: %d/%d \n",idx+n_train, n_trials+n_train);

    % populate the trial data
    clip_number = clip_order(idx);  %which clip parameters are we using
    [clipIdx,offsetIdx, repIdx] = ind2sub(size(raw_results_table),clip_number); % where is the clip located in the table
    raw_results_time(idx).clipIdx = clipIdx;
    raw_results_time(idx).clipName = clipNames(clipIdx);
    raw_results_time(idx).offsetIdx = offsetIdx;
    raw_results_time(idx).relOffset = rel_offsets(clipIdx, offsetIdx);
    raw_results_time(idx).absOffset = abs_offsets(offsetIdx);
    raw_results_time(idx).baseOffset = base_offsets(clipIdx);
    raw_results_time(idx).repIdx = repIdx;

    % play the clip
    pause(1);
    playShiftedAudio(clips(clipIdx), rel_offsets(clipIdx,offsetIdx), true);

    % ToDo: Gather response - Change to a graphical interface
    pause(0.5);
    prompt = "Did the gap between the speakers hae a natural length (ie. not too long or not too short)? Answer 1 for yes. Answer 0 for no. \nAnswer: ";
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
    elaspsedTime = toc;
    fprintf("Experiment runtime: %.3f s \n", elaspsedTime);
end

%% Post Stuff

%% Basic Process
%ToDo: Calculate average naturalness per clip per offset

%% Save the data into a .mat file
%Create entry in participant_key 
keyPath = fullfile(resultspath, "participant_key.txt");
file = fopen(keyPath, 'a+');
fprintf(file, sprintf('%s \t \t %s \n', participant_initials, fileBase));
fclose(file);

%save data
dataFile = fullfile(resultspath,fileBase + ".mat");
save(dataFile, "participant_ID","rel_offsets","abs_offsets","base_offsets","clipNames","raw_results_time", "raw_results_table", "elaspsedTime");
fprintf("Data saved into: %s \n", dataFile);

