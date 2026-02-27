classdef AudioClip
    properties
        t           % time vector
        audio       % each column is one channel
        fs          % sampling rate
        idxFirst   % idx of channel that holds the first speaker
        idxSecond  % idx of channel that holds the second speaker
        audio_1     % first speakers audio values
        audio_2     % second speakers audio values
    end

    methods
        function obj = AudioClip(t, audio, fs, idxFirst, idxSecond, audio_1, audio_2)
            if nargin == 3
                obj.t = t;
                obj.audio = audio;
                obj.fs = fs;
            end
            
            if nargin == 5
                obj.t = t;
                obj.audio = audio;
                obj.fs = fs;
                obj.idxFirst = idxFirst;
                obj.idxSecond = idxSecond;
            end
            
            if nargin == 7
                obj.t = t;
                obj.audio = audio;
                obj.fs = fs;
                obj.idxFirst = idxFirst;
                obj.idxSecond = idxSecond;
                obj.audio_1 = audio_1;
                obj.audio_2 = audio_2;
            end
        end
    end
end