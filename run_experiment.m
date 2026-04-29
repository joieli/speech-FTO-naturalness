%% THIS IS THE MAIN EXPERIMENT
% function run_experiment(participant_initials, participant_ID)
%     putCodeHere!!
% end


%Temp: Placeholders for the parameters that need to be passed to the
%function
clear; clc; close all;
participant_initials = 'test';
participant_ID = 'subjectXX';

%% Parameters
%paths
resultspath = "results";
audiopath = "audio_clips";
clipNames = [
    "F1M1_quiet_games_clip01";
    "F1M1_quiet_games_clip04";
    "F1M1_quiet_games_clip05";
    "F1M1_quiet_games_clip06";
    "F1M1_quiet_games_clip08"
];
clipNames = [
    "F1F2_quiet_food_clip07";
    "F1F2_quiet_food_clip08";
    "F1F2_quiet_food_clip11"; 
    "F1F2_quiet_food_clip13"; 
    "F1F2_quiet_food_clip14";

    "F1M1_quiet_games_clip01";
    "F1M1_quiet_games_clip04";
    "F1M1_quiet_games_clip05";
    "F1M1_quiet_games_clip06";
    "F1M1_quiet_games_clip08";

    "F2M1_quiet_birthday_clip01";
    "F2M1_quiet_birthday_clip02";
    "F2M1_quiet_birthday_clip03";
    "F2M1_quiet_birthday_clip05";
    "F2M1_quiet_birthday_clip06";
    "F2M1_quiet_birthday_clip07";
];
trainNames = [
    "F1F2_quiet_food_clip01";
    "F1F2_quiet_food_clip05"; 
    "F1F2_quiet_food_clip17";
    "F1M1_quiet_games_clip07";
];

%parameters
%abs_offsets = {0,900,2000,"base"};
abs_offsets = {0,100,200,400,600,900,1200,1600,2000,"base"};             %absolute_offsets in ms, acesss with abs_offsets{offsetIdx} - curly brace because cell, add "base" on the end to also test the no aritificial offset condition
reps_per_offset_per_clip = 1;                                % how many repetitions of each offset to present the participant                        

timeMe = true;
n_breaks = 2;

%training
runTrain = true;
train_reps_per_clip = 1;

%Create subject string
fileBase = string(datetime('now'),'yyyyMMdd_HH_mm_ss') + "__" + participant_ID;

%calculate some numbers
n_offsets = length(abs_offsets);
n_clips = length(clipNames);
n_trials = n_clips*n_offsets*reps_per_offset_per_clip;

n_trainClips = length(trainNames);

%% Creating placeholders to store data
% create table to store audio clips and data
clips(n_clips) = AudioClip;                                                 %access with clips(clipIdx).property
base_offsets = zeros(n_clips,1);                                               %access with base_offsets(clipIdx)
rel_offsets = zeros(n_clips,n_offsets);                                     %access with rel_offsets(clipIdx, offsetIdx) 

trainClips(n_trainClips) = AudioClip;
train_base_offsets = zeros(n_trainClips,1);
train_rel_offsets = zeros(n_trainClips,n_offsets);

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

for trainIdx = 1:n_trainClips
    trainClips(trainIdx) = load_audio_clip(audiopath, trainNames(trainIdx), true);
    train_base_offsets(trainIdx) = getBaseOffset(audiopath,trainNames(trainIdx));
    trainClips(trainIdx).base_offset = train_base_offsets(trainIdx);

    %leave the last element as a zero relative offset (represents no shift)
    for offsetIdx = 1:n_offsets-1
        train_rel_offsets(trainIdx, offsetIdx) = abs_offsets{offsetIdx}-train_base_offsets(trainIdx);
    end
end


%% Get experiment order and breaks
%get clip order
clip_order = getpRandClipOrder(n_clips, n_offsets, reps_per_offset_per_clip);

%figuring out training set
n_train = 0;
if runTrain == true
    n_train = n_trainClips*train_reps_per_clip;

    % get the clip order
    train_order = getTrainOrder(n_trainClips, n_offsets, train_reps_per_clip);
end

% figuring out where to put the breaks
break_points = round(linspace(1, n_train+n_trials, n_breaks + 2));
break_points = break_points(2:end-1);
curBlock = 1;

%% Experiment Begin - Go through the clips
fprintf("EXPERIMENT BEGINS: %s \n", fileBase);

try
    %create gui
    gui = createResponseGUI();
    gui.trialText.String = sprintf("Participant: %s \n",participant_initials);
    
    %start white noise to adjust volume
    Fs = 44100;          % sample rate
    noiseDuration = 60;  % long enough so it loops for a while
    whiteNoise = randn(Fs * noiseDuration, 1);
    whiteNoise = 0.06 * whiteNoise / max(abs(whiteNoise));
    noisePlayer = audioplayer(whiteNoise, Fs);
    
    updateResponseGUI(gui,'start');
    play(noisePlayer); % start white noise
    waitForResponse(gui);
    stop(noisePlayer); %stop the white noise after the response
    
    % start timer
    if timeMe
        tic;
    end
    
    % Running training trials
    if runTrain == true
        for idx = 1:n_train
            % Check if we need to take a break
            if ismember(idx, break_points)
                curBlock = curBlock + 1; %advance the counter to the next block
    
                gui.trialText.String = sprintf("Practice Clip \n");
                
                updateResponseGUI(gui,'disable'); % this gets rid of previous buttons highlights
                updateResponseGUI(gui,'break');
                waitForResponse(gui);
            end
            
            gui.trialText.String = sprintf("Practice Clip \n");
    
            %get trial data
            clip_number = train_order(idx);  %which clip parameters are we using
            [trainIdx,offsetIdx, ~] = ind2sub([n_trainClips, n_offsets, 1],clip_number);
    
            % play the clip
            updateResponseGUI(gui, 'playing');
            pause(0.75);
            playShiftedAudio(trainClips(trainIdx), train_rel_offsets(trainIdx,offsetIdx), true);
    
            %Gather response
            pause(0.75);
            updateResponseGUI(gui, 'question');
            response = waitForResponse(gui);
    
            % do not log response
        end
    end
    
    % running actual experiment
    for idx = 1:n_trials
        % check if we need to take a break
        if ismember(idx+n_train, break_points)
            curBlock = curBlock + 1;
            gui.trialText.String = sprintf("Block: %d/%d \n",curBlock, n_breaks+1);
    
            updateResponseGUI(gui,'disable'); % this gets rid of previous button highlights
            updateResponseGUI(gui,'break');
            waitForResponse(gui);
        end
        
        gui.trialText.String = sprintf("Block: %d/%d \n",curBlock, n_breaks+1);
    
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
        updateResponseGUI(gui, 'playing');
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
    elaspsedTime = NaN;
    if timeMe
        elaspsedTime = toc;
        fprintf("Experiment runtime: %.3f s \n", elaspsedTime);
    end
    
    % Save participant data
    keyPath = fullfile(resultspath, "main_participant_key.txt");
    file = fopen(keyPath, 'a+');
    fprintf(file, sprintf('%s \t \t %s \t \t main\n', participant_initials, fileBase));
    fclose(file);
    
    %save trial data
    dataFile = fullfile(resultspath,fileBase + "_main.mat");
    save(dataFile, "participant_ID","rel_offsets","abs_offsets","base_offsets","clipNames","clip_order","trainNames","train_base_offsets","train_rel_offsets","train_order","raw_results_time", "raw_results_table", "elaspsedTime");
    fprintf("Data saved into: %s \n", dataFile);
    
    % end experiment
    pause(0.75);
    updateResponseGUI(gui,'disable'); % this gets ris of previous buttons highlights
    updateResponseGUI(gui,'end');
    waitForResponse(gui);
    
    % close window
    if exist('gui','var') && isvalid(gui.fig)
        delete(gui.fig);
    end
catch ME
    disp("Experiment crashed — saving backup...");

    elaspsedTime = NaN;
    if timeMe
        elaspsedTime = toc;
        fprintf("Experiment runtime: %.3f s \n", elaspsedTime);
    end

    keyPath = fullfile(resultspath, "main_participant_key.txt");
    file = fopen(keyPath, 'a+');
    fprintf(file, sprintf('%s \t \t %s \t \t CRASH\n', participant_initials, fileBase));
    fclose(file);

    dataFile = fullfile(resultspath,fileBase + "_mainCRASH.mat");
    save(dataFile, "participant_ID","rel_offsets","abs_offsets","base_offsets","clipNames","clip_order","trainNames","train_base_offsets","train_rel_offsets","train_order","raw_results_time", "raw_results_table", "elaspsedTime", "ME");
    fprintf("Data saved into: %s \n", dataFile);

    throw(ME)
end