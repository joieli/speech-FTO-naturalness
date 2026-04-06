%% THIS IS THE PILOT
% function run_pilot(participant_initials, participant_ID)
%     putCodeHere!!
% end


%Temp: Placeholders for the parameterse that need to be passed to the
%function
clear; clc; close all;
participant_initials = 'jl';
participant_ID = 'subject02';


%% Parameters
rng(42);

%paths
audiopath = "audio_clips";
clipNames = ["F1F2_quiet_food_clip01","F1F2_quiet_food_clip05","F1F2_quiet_food_clip07","F1F2_quiet_food_clip08"...
    ,"F1F2_quiet_food_clip11", "F1F2_quiet_food_clip13", "F1F2_quiet_food_clip14", "F1F2_quiet_food_clip17"];     % audio clips to use, access with clipNames(clipIdx)
%clipNames = ["F1F2_quiet_food_clip01","F1F2_quiet_food_clip05","F1F2_quiet_food_clip07"];
resultspath = "results";

%parameters
abs_offsets = {0,400,800,1200,1600,2000,"base"};             %absolute_offsets in ms, acesss with abs_offsets{offsetIdx} - curly brace because cell, add "base" on the end to also test the no aritificial offset condition
%abs_offsets = {0,"base"};
reps_per_offset_per_clip = 4;                                       % how many repetitions of each offset to present the participant                        
%reps_per_offset_per_clip = 1;
timeMe = true;

%training
runTrain = true;
train_reps_per_clip = 2;
%train_reps_per_clip = 1;

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
raw_results_table = NaN(n_clips,n_offsets,train_reps_per_clip);    %access with raw_results_table(clipIdx, offsetIdx,repIdx) - each table is a repetition, each row is a clip, each col is a different offset 
raw_results_time(n_trials) = Trial;                                         %access with raw_results_time(idx).property

%% Load audios
for clipIdx = 1:n_clips
    clips(clipIdx) = load_audio_clip(audiopath, clipNames(clipIdx), true);
    base_offsets(clipIdx) = getBaseOffset(audiopath,clipNames(clipIdx));
    clips(clipIdx).base_offset = base_offsets(clipIdx);

    %leave the last element as a zero relative offset (represents no shift)
    for offsetIdx = 1:n_offsets-1
        rel_offsets(clipIdx, offsetIdx) = abs_offsets{offsetIdx}-base_offsets(clipIdx);
    end
end


%% Experiment Begin - Go through the clips
%get clip order
clip_order = getpRandClipOrder(n_clips, n_offsets, reps_per_offset_per_clip);

% Exerpiment start
fprintf("PILOT BEGINS: %s \n", fileBase);

%create gui
gui = createResponseGUI();
updateResponseGUI(gui,'start');
gui.trialText.String = participant_initials;
waitForResponse(gui);

% start timer
if timeMe
    tic;
end

% Running training trials
n_train = 0;
if runTrain == true
    n_train = n_clips*train_reps_per_clip;
    
    % get the clip order
    train_order = getTrainOrder(n_clips, n_offsets, train_reps_per_clip);

    for idx = 1:n_train
        gui.trialText.String = sprintf("Trial: %d/%d \n",idx, n_trials+n_train);

        %get trial data
        clip_number = train_order(idx);  %which clip parameters are we using
        [clipIdx,offsetIdx, repIdx] = ind2sub(size(raw_results_table),clip_number);

        % play the clip
        updateResponseGUI(gui, 'playing', sprintf("Trial: %d/%d \n",idx, n_trials+n_train));
        pause(0.75);
        playShiftedAudio(clips(clipIdx), rel_offsets(clipIdx,offsetIdx), true);

        %Gather response
        pause(0.5);
        updateResponseGUI(gui, 'question');
        response = waitForResponse(gui);

        % do not log response
    end
end

% running actual experiment
for idx = 1:n_trials
    gui.trialText.String = sprintf("Trial: %d/%d \n",idx+n_train, n_trials+n_train);

    % populate the trial data
    clip_number = clip_order(idx);  %which clip parameters are we using
    [clipIdx,offsetIdx, repIdx] = ind2sub(size(raw_results_table),clip_number); % where is the clip located in the table
    raw_results_time(idx).clipIdx = clipIdx;
    raw_results_time(idx).clipName = clipNames(clipIdx);
    raw_results_time(idx).offsetIdx = offsetIdx;
    raw_results_time(idx).relOffset = rel_offsets(clipIdx, offsetIdx);
    raw_results_time(idx).absOffset = abs_offsets{offsetIdx};
    raw_results_time(idx).baseOffset = base_offsets(clipIdx);
    raw_results_time(idx).repIdx = repIdx;

    % play the clip
    updateResponseGUI(gui, 'playing', sprintf("Trial: %d/%d \n",idx+n_train, n_trials+n_train));
    pause(1);
    playShiftedAudio(clips(clipIdx), rel_offsets(clipIdx,offsetIdx), true);

    %Gather response
    pause(0.75);
    updateResponseGUI(gui, 'question');
    response = waitForResponse(gui);

    %Log response
    raw_results_time(idx).soundsNatural = response;
    raw_results_table(clipIdx,offsetIdx, repIdx) = response;
end 

disp("EXPERIMENT DONE!")
disp("     ")

%stop timer
if timeMe
    elaspsedTime = toc;
    fprintf("Experiment runtime: %.3f s \n", elaspsedTime);
end

% Save participant data
keyPath = fullfile(resultspath, "participant_key.txt");
file = fopen(keyPath, 'a+');
fprintf(file, sprintf('%s \t \t %s \n', participant_initials, fileBase));
fclose(file);

%save trial data
dataFile = fullfile(resultspath,fileBase + ".mat");
save(dataFile, "participant_ID","rel_offsets","abs_offsets","base_offsets","clipNames","raw_results_time", "raw_results_table", "elaspsedTime");
fprintf("Data saved into: %s \n", dataFile);

% end experiment
pause(0.75);
updateResponseGUI(gui,'disable');
updateResponseGUI(gui,'end');
waitForResponse(gui);

% close window
if exist('gui','var') && isvalid(gui.fig)
    delete(gui.fig);
end