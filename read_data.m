close all;
load("results\20260414_08_57_25__subject03_pilot.mat")

means = mean(raw_results_table,3);
stds = std(raw_results_table,0,3); %normalizing by N-1 for the unbiased estimator

%make x axis
n_offsets = numel(abs_offsets);
x = NaN(1,n_offsets-1);
for i = 1:n_offsets-1
    x(i) = abs_offsets{i};
end

n_clips = numel(clipNames);
for clipIdx = 1:n_clips
    figure
    hold on
    errorbar(x, means(clipIdx,1:end-1), stds(clipIdx,1:end-1))
    errorbar(base_offsets(clipIdx), means(clipIdx, end), stds(clipIdx,end),'o')
    xlabel("Offset")
    ylabel("Naturalness")
    title(clipNames(clipIdx))
    xlim([-100,2100])
    ylim([-0.5,1.5])
    legend({'', 'Base Offset'})
    hold off
end

fullfan(1)