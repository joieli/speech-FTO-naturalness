function noise_norm = ssn(args)
    %  Generates spectrally shaped noise using the spectrum of a provided signal
    %
    % Inputs:
    %   filename   - String, path to the input speech audio file
    %   n_samples  - Integer, desired length of the output noise in samples
    %
    % Outputs:
    %   noise      - Vector containing the generated speech-shaped noise
    %
    % Example:
    %   noise = ssn('speech.wav', 48000);

    arguments
        args.filename (1, :) char
        args.n_samples (1, 1) double
    end

    % Parse input arguments
    filename = args.filename;
    n_samples = args.n_samples;

    % Load and replicate audio signal
    speech = audioread(filename);
    n_reps = ceil(n_samples / numel(speech));
    speech_rep = repmat(speech, n_reps, 1);
    speech_norm = speech_rep / max(abs(speech_rep));

    % FFT with random phase components
    mag = abs(fft(speech_norm));
    phs = exp(1i * 2 * pi * rand(size(speech_norm)));
    spectrum = mag .* phs;

    % Truncate to desired length
    noise = real(ifft(spectrum));
    noise_trunc = noise(1:n_samples);
    noise_norm = noise_trunc / rms(abs(noise_trunc));
end
