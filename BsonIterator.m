classdef BsonIterator
    properties
        h
    end

    methods
        function i = BsonIterator(varargin)
            i.h = libpointer('bson_iterator_Ptr');
            if nargin > 0
                b = varargin{1};
                if isa(b, 'Bson')
                    calllib('MongoMatlabDriver', 'mongo_bson_iterator_create', b.h, i.h);
                else
                    calllib('MongoMatlabDriver', 'mongo_bson_subiterator', b.h, i.h);
                end
            end
        end

        function t = type(i)
            if isNull(i.h)
                t = BsonType.EOO
            else
                t = BsonType(calllib('MongoMatlabDriver', 'mongo_bson_iterator_type', i.h));
            end
        end

        function t = next(i)
            if isNull(i.h)
                t = BsonType.EOO
            else
                t = BsonType(calllib('MongoMatlabDriver', 'mongo_bson_iterator_next', i.h));
            end
        end

        function k = key(i)
            k = calllib('MongoMatlabDriver', 'mongo_bson_iterator_key', i.h);
        end

        function v = value(i)
            switch (i.type)
                case {BsonType.EOO, BsonType.UNDEFINED, BsonType.NULL}
                    v = [];
                case BsonType.DOUBLE
                    v = calllib('MongoMatlabDriver', 'mongo_bson_iterator_double', i.h);
                case {BsonType.STRING, BsonType.SYMBOL}
                    v = calllib('MongoMatlabDriver', 'mongo_bson_iterator_string', i.h);
                case BsonType.OBJECT
                    error('BsonIterator:value', 'Iterator points to a subobject. Use subiterator().');
                case BsonType.ARRAY
                    v = calllib('MongoMatlabDriver', 'mongo_bson_array_value', i.h);
                case BsonType.BINDATA
                    s = calllib('MongoMatlabDriver', 'mongo_bson_iterator_bin_len', i.h);
                    v = zeros([1, s], 'uint8');
                    p = libpointer('uint8Ptr', v);
                    calllib('MongoMatlabDriver', 'mongo_bson_iterator_bin_value', i.h, p);
                    v = p.Value;
                case BsonType.OID
                    v = zeros([1, 12], 'uint8');
                    p = libpointer('uint8Ptr', v);
                    calllib('MongoMatlabDriver', 'mongo_bson_iterator_oid', i.h, p);
                    v = BsonOID(p.Value);
                case BsonType.BOOL
                    v = (calllib('MongoMatlabDriver', 'mongo_bson_iterator_bool', i.h) ~= 0);
                case BsonType.DATE
                    v =  719529 + calllib('MongoMatlabDriver', 'mongo_bson_iterator_date', i.h) / (1000 * 60 * 60 * 24);
                case BsonType.REGEX
                    v = BsonRegex(calllib('MongoMatlabDriver', 'mongo_bson_iterator_regex', i.h), ...
                                  calllib('MongoMatlabDriver', 'mongo_bson_iterator_regex_opts', i.h));
                case BsonType.DBREF
                    error('BsonIterator:value', 'No support for deprecated DBREF');
                case BsonType.CODE
                    v = calllib('MongoMatlabDriver', 'mongo_bson_iterator_code', i.h);
                case BsonType.CODEWSCOPE
                    scope = Bson();
                    calllib('MongoMatlabDriver', 'mongo_bson_iterator_code_scope', i.h, scope.h);
                    v = BsonCodeWScope(calllib('MongoMatlabDriver', 'mongo_bson_iterator_code', i.h), scope);
                case BsonType.INT
                    v = int32(calllib('MongoMatlabDriver', 'mongo_bson_iterator_int', i.h));
                case BsonType.LONG
                    v = int64(calllib('MongoMatlabDriver', 'mongo_bson_iterator_long', i.h));
                otherwise
                    error('BsonIterator:value', 'Unknown BSON type: %d', i.type);
            end
        end

        function t = binaryType(i)
            if i.type == BsonType.BINDATA
               t = calllib('MongoMatlabDriver', 'mongo_bson_iterator_bin_type', i.h);
            else
                error('BsonIterator:binaryType', 'Expected a binary BSON field');
            end
        end

        function si = subiterator(i)
            si = BsonIterator(i);
        end

        function clear(i)
            calllib('MongoMatlabDriver', 'mongo_bson_iterator_free', i.h);
            clear i.h;
        end

    end
end


