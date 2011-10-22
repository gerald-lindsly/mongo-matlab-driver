classdef BsonTimestamp
    % BsonTimestamp - Used for BsonType.TIMESTAMP
    % Objects of this class are detected by BsonBuffer.append() and
    % returned by Bson.value() and BsonIterator.value().
    properties
        date        % The date of this timestamp (double datenum)
        increment   % The increment of this timestamp (int32)
    end
    methods
        function bts = BsonTimestamp(date_, increment_)
            bts.date = date_;
            bts.increment = increment_;
        end
    end
end

        