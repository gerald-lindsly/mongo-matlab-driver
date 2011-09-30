classdef BsonBuffer
    properties
        h = libpointer
    end

    methods
        function bb = BsonBuffer()
            calllib('MongoMatlabDriver', 'mongo_bson_buffer_create', bb.h)
        end

        function ok = append(bb, name, value)
            ok = calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_int', bb.h, name, value)
        end

        function b = finish(bb)
            h2 = libpointer
            calllib('MongoMatlabDriver', 'mongo_bson_buffer_to_bson', bb.h, h2)
            b = Bson(h2)
            clear bb.h
        end

    end
end
