classdef BsonBuffer
    properties
        h = libpointer('bson_bufferPtr');
    end

    methods
        function bb = BsonBuffer()
            calllib('MongoMatlabDriver', 'mongo_bson_buffer_create', bb.h);
        end

        function ok = append(bb, name, value)
            if isa(value, 'char')
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_string', bb.h, name, value) ~= 0);
            elseif isa(value, 'float')
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_double', bb.h, name, value) ~= 0);
            elseif isa(value, 'int64') | isa(value, 'uint64')
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_long', bb.h, name, value) ~= 0);
            elseif isa(value, 'BsonOID')
                p = libpointer('uint8Ptr', value.value)
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_oid', bb.h, name, p) ~= 0);
            else
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_int', bb.h, name, value) ~= 0);
            end
        end

        function ok = appendBinary(bb, name, value, varargin)
            if isa(value, 'int8') | isa(value, 'uint8')
                t = 0;
                if nargin > 3
                    t = varargin;
                end
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_binary', bb.h, name, t, value, numel(value)) ~= 0);
            else
                error('BsonBuffer:appendBinary', 'value must be int8 or uint8');
            end
        end

        function ok = startObject(bb, name)
            ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_start_object', bb.h, name) ~= 0);
        end

        function ok = finishObject(bb)
            ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_finish_object', bb.h) ~= 0);
        end

        function b = finish(bb)
            b = Bson;
            calllib('MongoMatlabDriver', 'mongo_bson_buffer_to_bson', bb.h, b.h);
            clear bb.h;
        end

    end
end
