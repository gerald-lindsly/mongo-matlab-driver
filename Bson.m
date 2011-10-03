classdef Bson
    properties
        h = libpointer('bson_Ptr')
    end

    methods
        function s = size(b)
            s = calllib('MongoMatlabDriver', 'mongo_bson_size', b.h);
        end

        function i = iterator(b)
            i = BsonIterator(b)
        end

        function clear(b)
            calllib('MongoMatlabDriver', 'mongo_bson_free', b.h);
            clear b.h;
        end

    end
end
