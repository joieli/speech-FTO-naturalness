close all; clear; clc;
subject4 = load("results\20260417_14_05_18__subject04_pilot.mat");
subject5 = load("results\20260417_16_12_37__subject05_pilot.mat");

all_results = zeros([size(subject4.raw_results_table),2]);
all_results(:,:,:,1) = subject4.raw_results_table;
all_results(:,:,:,2) = subject5.raw_results_table;

base_offsets = subject4.base_offsets;
abs_offsets = subject4.abs_offsets;
rel_offsets = subject4.rel_offsets;
clipNames = subject4.clipNames;

%make x axis
n_offsets = numel(abs_offsets);
abs_x = NaN(1,n_offsets-1);
for i = 1:n_offsets-1
    abs_x(i) = abs_offsets{i};
end

n_clips = numel(clipNames);
n_participants = size(all_results,4);
%% Plots per clip
means = mean(all_results,[3,4]); %averaging over each trial and each participant

% plot against abs_offset
figure
sgtitle(sprintf("Averaged across %d participants, against absolute offset", n_participants))
for clipIdx = 1:n_clips
    subplot(2,4,clipIdx)
    hold on
    plot(abs_x, means(clipIdx,1:end-1), 'o-')
    scatter(base_offsets(clipIdx), means(clipIdx, end),'o')
    xlabel("Absolute Offset")
    ylabel("Naturalness")
    title(clipNames(clipIdx))
    xlim([-100,2100])
    ylim([-0.25,1.25])
    legend({'', 'Base Offset'})
    hold off
end

% against relative offsets
figure
sgtitle(sprintf("Averaged across %d participants, against relative offset", n_participants))
for clipIdx = 1:n_clips
    subplot(2,4,clipIdx)
    hold on
    plot(rel_offsets(clipIdx,1:end-1), means(clipIdx,1:end-1), 'o-')
    scatter(rel_offsets(clipIdx, end), means(clipIdx, end),'o')
    xlabel("Relative Offset")
    ylabel("Naturalness")
    title(clipNames(clipIdx))
    xline(0, 'LineWidth',1)
    yline(0, 'LineWidth',1)
    ylim([-0.1,1.25])
    legend({'', 'Base Offset'})
    hold off
end

%% Plots per participant

% plot against abs_offset, averaging across each clip
means = mean(all_results, [3,1]); %averaging over each trial and each clip

figure
sgtitle(sprintf("Averaged across %d clips, against absolute offset", n_clips))
for partIdx = 1:n_participants
    subplot(1,2,partIdx)
    hold on
    plot(abs_x, means(:,1:end-1,1,partIdx), 'o-') % do not plot the last point because that averages across all the offsets
    xlabel("Absolute Offset")
    ylabel("Naturalness")
    title(sprintf("Participant %d", partIdx))
    xlim([-100,2100])
    ylim([-0.25,1.25])
    hold off
end

% plot against relative offsets, scatter across all the relative offsets
means = mean(all_results, 3); %averaging over each trial

figure
sgtitle(sprintf("All %d clips, against relative offset", n_clips))
for partIdx = 1:n_participants
    subplot(1,2,partIdx)
    hold on
    scatter(rel_offsets, means(:,:,:,partIdx), 'o')
    xlabel("Relative Offset")
    ylabel("Naturalness")
    title(sprintf("Participant %d", partIdx))
    xline(0, 'LineWidth',1)
    yline(0, 'LineWidth',1)
    ylim([-0.1,1.25])
    hold off
end

%% Plots overall

% plot against absolute offset
means = mean(all_results, [3,4,1]); %averaging over each trial, each participant, each clip

figure
plot(abs_x, means(1:end-1), 'o-') % do not plot the last point because that averages across all the base offsets
xlabel("Absolute Offset")
ylabel("Naturalness")
title(sprintf("Averaged across %d clips and %d participants, against absolute offset", n_clips, n_participants))
xlim([-100,2100])
ylim([-0.25,1.25])

% plot against relative offset
means = mean(all_results,[3,4]); %averaging over each trial and each participant

figure
scatter(rel_offsets', means', 'bo')
xlabel("Relative Offset")
ylabel("Naturalness")
title(sprintf("Averaged across %d participants, against relative offset", n_participants))
xline(0, 'LineWidth',1)
yline(0, 'LineWidth',1)
ylim([-0.1,1.25])

%% plot elbow point vs base offset
