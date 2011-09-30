classdef Bson
    properties
        h = libpointer
    end

    methods
        function b = Bson(h)
            b.h = h
        end

        function s = size(b)
            s = calllib('MongoMatlabDriver', 'mongo_bson_size', b.h)
        end

        function display(b)

        end

        function clear(b)
            clear b.h
        end

    end
end
