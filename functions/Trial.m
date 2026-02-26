classdef Trial
    properties
        clipIdx     % idx of the clip played
        clipName    % file name of the original clip
        offsetIdx   % idx of the offset
        relOffset   % relative value of the FTO (ie. -100 ms)
        absOffset   % absolute value of the FTO (ie. 223 ms)
        repIdx      % idx of the repetion (ie. 1 of 5 at this offset)
        soundsNatural   % bool: participant's response
    end

    methods
        function obj = Trial(clipIdx, clipName, offsetIdx, relOffset, absOffset, repIdx, soundsNatural)
            if nargin > 0
                obj.clipIdx = clipIdx;
                obj.clipName = clipName;
                obj.offsetIdx = offsetIdx;
                obj.relOffset = relOffset;
                obj.absOffset = absOffset;
                obj.repIdx = repIdx;
                obj.soundsNatural = soundsNatural;
            end
        end
    end
end