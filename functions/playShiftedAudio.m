function shiftedClip = playShiftedAudio(clip, relOffset, noise, noiseGain) %relOffset in ms
    if nargin < 4
        noiseGain = 0.2;
    end

    % Getting details of the audio clip
    t = clip.t;
    audio = clip.audio;
    fs = clip.fs;
    idxFirst = clip.idxFirst;
    idxSecond = clip.idxSecond;
    base_offset = clip.base_offset;
    
    
    % shift the audio
    T_shift = floor(relOffset/1000); %convert ms to seconds
    [audio_shifted, audio_1, audio_2, t_shifted] = speaker_shift(audio(:, [idxFirst, idxSecond]), fs, T_shift);

    %add noise if desired
    if noise == true
        % Generate white noise
        noise = rand(numel(t_shifted), 1);
        
        % Amplifiy noise relative to rms of original audio clip and add to signal
        scale_factor_noise = rms(abs(sum(audio_shifted, 2))) / rms(abs(noise));
        noise_gained = noiseGain * scale_factor_noise * noise;
        audio_shifted = audio_shifted + noise_gained;
    end

    %randomly swap left and right channels
    if rand > 0.5
        audio_shifted = audio_shifted(:, [2 1]); % swap left and right
    end

    % save the clip
    shiftedClip = AudioClip(t_shifted, audio_shifted, fs, idxFirst, idxSecond, audio_1, audio_2, base_offset, relOffset);

    %play sound
    soundsc(shiftedClip.audio, shiftedClip.fs)
    pause(max(shiftedClip.t) + 1)
end