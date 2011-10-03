classdef BsonIterator
    properties
        h = libpointer('bson_iterator_Ptr')
    end

    methods
        function i = BsonIterator(b)
            if strcmp(class(b), 'Bson')
                calllib('MongoMatlabDriver', 'mongo_bson_iterator_create', b.h, i.h);
            else
                calllib('MongoMatlabDriver', 'mongo_bson_subiterator', b.h, i.h);
            end
        end

        function t = type(i)
            t = BsonType(calllib('MongoMatlabDriver', 'mongo_bson_iterator_type', i.h));
        end

        function t = next(i)
            t = calllib('MongoMatlabDriver', 'mongo_bson_iterator_next', i.h);
        end

        function k = key(i)
            k = calllib('MongoMatlabDriver', 'mongo_bson_iterator_key', i.h);
        end

        function v = value(i)
            switch (i.type)
                case {BsonType.EOO, BsonType.UNDEFINED}
                    v = [];
                case BsonType.DOUBLE
                    v = calllib('MongoMatlabDriver', 'mongo_bson_iterator_double', i.h);
                case BsonType.STRING
                    v = calllib('MongoMatlabDriver', 'mongo_bson_iterator_string', i.h);
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
                    p.Value
                    class(p.Value)
                    v = BsonOID(p.Value);
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
