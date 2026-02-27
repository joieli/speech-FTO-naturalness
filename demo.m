%% Initialization
clearvars; close all; clc;

% Read audio file
audiopath = 'audio_clips';
audio_name = 'F1F2_quiet_food_clip01';
clipID = 2;

clip = load_audio_clip(audiopath, audio_name, false);
t = clip.t;
audio = clip.audio;
fs = clip.fs;
idx_first = clip.idxFirst;
idx_second = clip.idxSecond;

%% Plot and play audio signal

% Plot full audio signals
figure(1); clf;
plot(t, audio(:, 1), "DisplayName", "Mic 1 (left)"); hold on;
plot(t, audio(:, 2), "DisplayName", "Mic 2 (right)");
legend;
xlabel("Time (s)");
ylabel("Amplitude");
title("Full audio signal for selected clip");

% Play full audio signal (L/R split)
soundsc(audio, fs)
pause(max(t) + 1)

%% Plot showing how talker 2 is audible in mic 1
figure(2); clf;
tmax = ceil(numel(t) / 4);
tiledlayout(2, 1)
nexttile
plot(t(1:tmax), audio(1:tmax, idx_first), "DisplayName", "First speaker"); hold on;
plot(t(1:tmax), audio(1:tmax, idx_second), "DisplayName", "Second speaker");
legend;
xlabel("Time (s)");
ylabel("Amplitude");
title("First 1/4 of audio")
nexttile
plot(t(1:tmax), audio(1:tmax, idx_second))
title("Second speaker - zoomed in")
xlabel("Time (s)");
ylabel("Amplitude");

% Play channel 1 only to hear the crosstalk
soundsc(audio(:, 1), fs)

%% If there is crosstalk, this will ruin our stimulus when we try to shift the speakers in time. Notice the "echo" in this example:

% Shift audio
T_shift = -1;
[y_shifted, y1, y2, t_shifted] = speaker_shift(audio(:, [idx_first, idx_second]), fs, T_shift);

% Plot shifted audio
figure(3); clf;
plot(t_shifted, y1, "DisplayName", "First Speaker"); hold on;
plot(t_shifted, y2, "DisplayName", "Second Speaker");
xlabel("Time (s)");
ylabel("Amplitude");

soundsc(y_shifted, fs)
pause(max(t_shifted) + 1)

% Let's see if we can isolate the two speakers better.
% Three different methods are shown here:
% 1) Manual gating of the stimulus
% 2) Gating with automatic Voice Activity Detection (VAD)
% 3) Adding noise to mask the crosstalk

%% 1) Manual gating
% Manually set time intervals where each speaker is silent
% This can be done in a software like Audacity or ELAN, or by writing code to set certain time intervals to zero.
% This is somewhat time-consuming and needs to be redone for each stimulus, but will probably give the best results.
% I have prepared manual labels for the 17 clips in the repository.
% Note that some still have residual crosstalk which I could not eliminate without affecting the main speaker's speech: clip06, clip09, clip 16

% Load audio with manual gating option set to true
clipManual = load_audio_clip(audiopath, audio_name, true);
audio_manual = clipManual.audio;

% Plot gated audio
figure(6); clf;
plot(t, audio_manual(:, 1), "DisplayName", "Mic 1 (gated)"); hold on;
plot(t, audio_manual(:, 2), "DisplayName", "Mic 2 (gated)");
xlabel("Time [s]");

% Play gated audio
soundsc(audio_manual, fs)

%%
% Play shifted audio - With manual gating
T_shift = -1;
y_tot_manual = speaker_shift(audio_manual(:, [idx_first, idx_second]), fs, T_shift);
soundsc(y_tot_manual, fs)

%% 2) Gating with automatic Voice Activity Detection (VAD)
% Let's try to kill the audio automatically whenever the main speaker isn't speaking
% To do this, we can use a VAD algorithm. Here we use rVAD by Tan et al. (2020).
% Paper: https://doi.org/10.1016/j.csl.2019.06.005. Code: https://github.com/zhenghuatan/rVAD (included in this project, see 'rVAD2.0' folder. Note the main function 'vad.m' is modified slightly here).
% Note that's solves the problem to some extent but can make mistakes, which can ruin the stimulus completely.

% Set VAD parameters (Controls how aggressive the VAD is)
VAD_threshold = 0.1;

% Run VAD on each channel
audio_vad = zeros(size(audio));

figure(4); clf;
tiledlayout(2, 1)

for c = [idx_first idx_second]

    % Run VAD and interpolate output to original time scale
    z = vad(audio(:, c), fs, [], 0, VAD_threshold);
    tz = linspace(0, t(end), numel(z));
    zr = interp1(tz, z, t)';

    % Plot audio along with VAD output
    nexttile
    plot(t, audio(:, c), DisplayName = "Original audio signal");
    hold on
    plot(t, zr * max(audio(:, c)), LineWidth = 2.7, DisplayName = "VAD output (gating signal)");
    xlabel("Time (s)");
    legend;

    % Play gated audio signal for one channel at a time
    audio_vad(:, c) = audio(:, c) .* zr;
    disp("Playing gated audio for channel " + c);
    soundsc(audio_vad(:, c), fs);
    pause(size(audio, 1) / fs)
end

%%
% Play shifted audio - With VAD gating
y_tot_vad = speaker_shift(audio_vad, fs, T_shift);
soundsc(y_tot_vad, fs)
pause(max(t_shifted) + 1)

%% 3) Adding noise to mask crosstalk
% Another option is to add noise to mask the crosstalk from the other speaker.
% This is probably more robustthan the VAD option, but might require very loud noise to be effective, which could affect the results.
% Here we use white noise, but it could also be babble noise those, which might mask more effectively at lower amplitudes.

% Generate white noise
noise = rand(2 * numel(t), 1);

% Amplifiy noise relative to rms of original audio clip and add to signal
g_noise = 0.2;
scale_factor_noise = rms(abs(sum(audio, 2))) / rms(abs(noise));
noise_gained = g_noise * scale_factor_noise * noise;
audio_with_noise = audio + noise_gained(1:numel(t));

% Plot and play with speakers split L/R
figure(5); clf; hold on;
plot(t, audio_with_noise(:, idx_first), DisplayName = "First Speaker");
plot(t, audio_with_noise(:, idx_second), DisplayName = "Second Speaker");
plot(t, noise_gained(1:numel(t)), DisplayName = "Noise");
xlabel("Time (s)");
ylabel("Amplitude");
legend;

% Play audio with noise
soundsc(audio_with_noise, fs)

%%
% Play shifted audio - With noise masking
soundsc(y_shifted + noise_gained(1:numel(t_shifted)), fs)
pause(max(t_shifted) + 1)

%% We can also try a combination of methods, for example VAD gating + noise masking:

y_tot_vad = speaker_shift(audio_vad, fs, T_shift);
soundsc(y_tot_vad + noise_gained(1:numel(t_shifted)), fs)

%% Or manual gating + noise masking:
y_tot_manual = speaker_shift(audio_manual(:, [idx_first, idx_second]), fs, T_shift);
soundsc(y_tot_manual + noise_gained(1:numel(t_shifted)), fs)
