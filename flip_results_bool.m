% flip results, use this if you want to turn all the "1" into "0s" and vice
% versa (ie. you asked the reverse questions
clear; clc; close all;
filename = "results\20260414_08_57_25__subject03_pilot.mat";
load(filename)

raw_results_table(:,:,:) = 1- raw_results_table(:,:,:);

for idx = 1:numel(raw_results_time)
    raw_results_time(idx).soundsNatural = 1 - raw_results_time(idx).soundsNatural;
end

save(filename)

