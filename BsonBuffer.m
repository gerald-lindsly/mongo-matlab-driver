classdef BsonBuffer < handle
    % BsonBuffer - used to build Bson objects
    properties
        h   % lib.pointer to external data
    end

    methods
        function bb = BsonBuffer()
            % bb = BsonBuffer()  Construct a new buffer.
            bb.h = libpointer('bson_bufferPtr');
            calllib('MongoMatlabDriver', 'mongo_bson_buffer_create', bb.h);
        end

        function s = size(bb)
            % s = bb.size()  Return the size of the buffer.
            % This is equal to the size of the BSON document that would be output
            % by finish().
            s = calllib('MongoMatlabDriver', 'mongo_bson_buffer_size', bb.h);
        end

        function ok = append(bb, name, value)
            % ok = bb.append(name, value) Append a name/value pair into this buffer.
            % Returns true(1) if the data was successfully appended; otherwise, false(0).
            % The type of value is detected and a wide variety of types are supported
            % by this function including multidimensional arrays of numerics and logicals.
            % The mapping to BsonTypes is as follows:
            % [] (empty)        NULL
            % Bson              OBJECT
            % BsonOid           OID
            % BsonRegex         REGEX
            % BsonCodeWScope    CODEWSCOPE
            % BsonTimestamp     TIMESTAMP
            % logical           BOOL
            % char              STRING
            % int8, uint8, int16, uint16, int32, uint32     INT
            % single, double    DOUBLE
            % complex double    subobject { "r" : real, "i" : imag }
            % There are some other 'append' functions to handle the BsonTypes not detected
            % by this generic function.
            if isempty(value)
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_null', bb.h, name) ~= 0);
            elseif isa(value, 'Bson')
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_bson', bb.h, name, value.h) ~= 0);
            elseif isa(value, 'BsonOID')
                p = libpointer('uint8Ptr', value.value);
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_oid', bb.h, name, p) ~= 0);
            elseif isa(value, 'BsonRegex')
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_regex', bb.h, name, value.pattern, value.options) ~= 0);
            elseif isa(value, 'BsonCodeWScope')
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_codewscope', bb.h, name, value.code, value.scope.h) ~= 0);
            elseif isa(value, 'BsonTimestamp')
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_timestamp', bb.h, name, ...
                              (value.date - 719529) * (60 * 60 * 24), value.increment) ~= 0);
            elseif isa(value, 'logical')
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append', bb.h, name, value) ~= 0);
            elseif isa(value, 'char')
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_string', bb.h, name, value) ~= 0);
            elseif isnumeric(value) && ~isreal(value) && ~isa(value, 'double')
                error('BsonBuffer:append', 'Only doubles are supported for complex values');
            elseif isnumeric(value)
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append', bb.h, name, value) ~= 0);
            else
                error('BsonBuffer:append', 'Don''t know how to handle type (%s)', class(value));
            end

        end

        function ok = appendBinary(bb, name, value, varargin)
            % ok = bb.appendBinary(name, value, ...)  Append a BsonType.BINDATA field
            % Returns true(1) if the data was successfully appended; otherwise, false(0).
            % only int8 or uint8 value types are supported.
            % Optionally, specify the subtype of the binary data.
            if isa(value, 'int8') | isa(value, 'uint8')
                t = 0;
                if nargin > 3
                    t = varargin{1};
                end
                ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_binary', bb.h, name, t, value, numel(value)) ~= 0);
            else
                error('BsonBuffer:appendBinary', 'value must be int8 or uint8');
            end
        end

        function ok = appendDate(bb, name, value)
            % ok = bb.appendDate(name, value)  Append date(s) to this buffer.
            % Returns true(1) if the data was successfully appended; otherwise, false(0).
            % Multidimension arrays of datenums are supported.
            ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_date', bb.h, name, value) ~= 0);
        end

        function ok = appendCode(bb, name, value)
            % ok = bb.appendCode(name, value)  Append a BsonType.CODE field to this buffer.
            % Returns true(1) if the data was successfully appended; otherwise, false(0).
            ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_code', bb.h, name, value) ~= 0);
        end

        function ok = appendSymbol(bb, name, value)
            % ok = bb.appendSymbol(name, value)  Append a BsonType.SYMBOL field to this buffer.
            % Returns true(1) if the data was successfully appended; otherwise, false(0).
            ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_append_symbol', bb.h, name, value) ~= 0);
        end

        function ok = startObject(bb, name)
            % ok = bb.startObject(name)  Start a nested subobject within this buffer.
            % Returns true(1) if the marker was successfully appended; otherwise, false(0).
            ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_start_object', bb.h, name) ~= 0);
        end

        function ok = finishObject(bb)
            % ok = bb.finishObject(name)  Finish a nested subobject.
            % Returns true(1) if the marker was successfully appended; otherwise, false(0).
            ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_finish_object', bb.h) ~= 0);
        end

        function ok = startArray(bb, name)
            % ok = bb.startArray(name)  Start an array within this buffer.
            % Returns true(1) if the marker was successfully appended; otherwise, false(0).
            ok = (calllib('MongoMatlabDriver', 'mongo_bson_buffer_start_array', bb.h, name) ~= 0);
        end

        function b = finish(bb)
            % b = bb.finish()  Finish with this buffer and turn it into a Bson object.
            b = Bson;
            calllib('MongoMatlabDriver', 'mongo_bson_buffer_to_bson', bb.h, b.h);
            clear bb.h;
            bb.h = [];
        end

        function delete(bb)
            % Release this buffer.
            % It is not necessary to call this function explicitly as Matlab will
            % call it automatically when this buffer is no longer referenced.
            if ~isempty(bb.h) && ~isNull(bb.h)
                calllib('MongoMatlabDriver', 'mongo_bson_buffer_free', bb.h);
            end
        end

    end
end
