classdef BsonTimestamp
    properties
        date
        increment
    end
    methods
        function bts = BsonTimeStamp(date_, increment_)
            bts.date = date_;
            bts.increment = increment_;
        end
    end
end

        