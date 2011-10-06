classdef BsonRegex
    properties
        pattern
        options
    end

    methods
        function br = BsonRegex(pattern_, options_)
            br.pattern = pattern_;
            br.options = options_;
        end
    end
end