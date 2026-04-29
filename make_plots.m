close all; clear; clc;
resultsPath = "results";
fileNames = [
    "20260417_14_05_18__subject04_pilot.mat";
    "20260417_16_12_37__subject05_pilot.mat";
];

n_participants = numel(fileNames);
for partIdx = 1:n_participants
    dataPath = fullfile(resultsPath, fileNames(partIdx));
    data(partIdx) = load(dataPath);
end

all_results = zeros([size(data(1).raw_results_table),n_participants]);
for partIdx = 1:n_participants
    all_results(:,:,:,partIdx) = data(partIdx).raw_results_table;
end
%all_results(:,:,:,1) = subject4.raw_results_table;
%all_results(:,:,:,2) = subject5.raw_results_table;


base_offsets = data(1).base_offsets;
abs_offsets = data(1).abs_offsets;
rel_offsets = data(1).rel_offsets;
clipNames = data(1).clipNames;

%make x axis
n_offsets = numel(abs_offsets);
abs_x = NaN(1,n_offsets-1);
for i = 1:n_offsets-1
    abs_x(i) = abs_offsets{i};
end

n_clips = numel(clipNames);
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
means = mean(all_results, 3); %averaging over each trial

figure
sgtitle(sprintf("Averaged across %d clips, against absolute offset", n_clips))
for partIdx = 1:n_participants
    subplot(1,2,partIdx)
    hold on
    average = mean(means,1); %everage over each clip
    plot(abs_x, average(:,1:end-1,1,partIdx),'-', LineWidth=1.5, DisplayName="average across clips") % do not plot the last point because that averages across all the offsets
    for clipIdx = 1:n_clips
        plot(abs_x, means(clipIdx,1:end-1,1,partIdx), 'o-', Color="#808080", HandleVisibility='off', LineWidth=0.5)
    end
    xlabel("Absolute Offset")
    ylabel("Naturalness")
    legend()
    title(data(partIdx).participant_ID)
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
    for clipIdx = 1:n_clips
        scatter(rel_offsets(clipIdx,:), means(clipIdx,:,:,partIdx), 'o')
    end
    %ToDo: Regression
    xlabel("Relative Offset")
    ylabel("Naturalness")
    title(data(partIdx).participant_ID)
    xline(0, 'LineWidth',1)
    yline(0, 'LineWidth',1)
    ylim([-0.1,1.25])
    hold off
end

%% Plots overall

% plot against absolute offset
means = mean(all_results, [3,1]); %averaging over each trial, each clip

figure
hold on
average = mean(means,4); %everage over each participant
plot(abs_x, average(1:end-1),'-', LineWidth=1.5, DisplayName="average across participants") % do not plot the last point because that averages across all the base offsets
for partIdx = 1:n_participants
    plot(abs_x, means(:,1:end-1,1,partIdx), 'o-', Color="#808080", HandleVisibility='off', LineWidth=0.5)
end
xlabel("Absolute Offset")
ylabel("Naturalness")
legend()
title(sprintf("Averaged across %d clips and %d participants, against absolute offset", n_clips, n_participants))
xlim([-100,2100])
ylim([-0.25,1.25])
hold off

% plot against relative offset
means = mean(all_results,[3,4]); %averaging over each trial and each participant

figure
hold on
for clipIdx = 1:n_clips
    scatter(rel_offsets(clipIdx,:), means(clipIdx,:), 'o')
end
%ToDo: Regression
xlabel("Relative Offset")
ylabel("Naturalness")
title(sprintf("Averaged across %d participants, against relative offset", n_participants))
xline(0, 'LineWidth',1)
yline(0, 'LineWidth',1)
ylim([-0.1,1.25])
hold off

%% plot elbow point vs base offset
