classdef BsonRegex
    % BsonRegex - Used for BsonType.REGEX regular expresssions
    % Objects of this class are detected by BsonBuffer.append() and
    % returned by Bson.value() and BsonIterator.value().
    properties
        pattern  % The pattern of this regex.
        options  % Options for this regex.
    end

    methods
        function br = BsonRegex(pattern_, options_)
            br.pattern = pattern_;
            br.options = options_;
        end
    end
end