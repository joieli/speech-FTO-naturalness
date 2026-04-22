%% Startup script for manipulated-FTOs project
% This script initializes the MATLAB environment by adding relevant folders to the path
clear; clc; close all;


% Get the root directory of this project
projectRoot = fileparts(mfilename('fullpath'));
cd(projectRoot);

% Add functions folder
functionsDir = fullfile(projectRoot, 'functions');
addpath(functionsDir);

% Add rVAD2.0 folder and subfolders
rVADDir = fullfile(projectRoot, 'rVAD2.0');
addpath(rVADDir);

% Add stimuli folder (for audio data)
stimuliDir = fullfile(projectRoot, 'audio_clips');
addpath(stimuliDir);

% Add results folder (for participant data)
resultsDir = fullfile(projectRoot, 'results');
addpath(resultsDir);

% Add gui folder
guiDir = fullfile(projectRoot, 'gui');
addpath(guiDir);

% Add classes folder
classesDir = fullfile(projectRoot, 'classes');
addpath(classesDir);

% Add rinor folder
rinorDir = fullfile(projectRoot, 'rinor-matlab-tools-main');
addpath(genpath(rinorDir));

% Display confirmation message
disp('Project initialized successfully!');
disp(['Project root: ' projectRoot]);
disp('Added to path:');
disp(['  - ' functionsDir]);
disp(['  - ' rVADDir]);
disp(['  - ' stimuliDir]);
disp(['  - ' resultsDir]);
disp(['  - ' guiDir]);
disp(['  - ' classesDir]);
