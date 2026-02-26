classdef AudioClip
    properties
        t           % time vector
        audio       % each column is one channel
        fs          % sampling rate
        idxFirst   % idx of channel that holds the first speaker
        idxSecond  % idx of channel that holds the second speaker
    end

    methods
        function obj = AudioClip(t, audio, fs, idxFirst, idxSecond)
            if nargin > 0
                obj.t = t;
                obj.audio = audio;
                obj.fs = fs;
                obj.idxFirst = idxFirst;
                obj.idxSecond = idxSecond;
            end
        end
    end
end