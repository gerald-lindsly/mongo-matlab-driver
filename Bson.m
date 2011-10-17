classdef Bson < handle
    properties
        h
    end

    methods (Static)
        function display_(i, depth)
            while i.next()
                t = i.type;
                if t == BsonType.EOO
                    break;
                end
                for j = 1:depth
                    fprintf(1, '\t');
                end
                fprintf(1, '%s (%d) : ', i.key, int32(t));
                switch (t)
                    case BsonType.DOUBLE
                       fprintf(1, '%f', i.value);
                    case {BsonType.STRING, BsonType.SYMBOL, BsonType.CODE}
                        fprintf(1, '%s', i.value);
                    case BsonType.OID
                        fprintf(1, '%s', i.value.toString());
                    case BsonType.BOOL
                        if i.value
                            fprintf(1, 'true');
                        else
                            fprintf(1, 'false');
                        end
                    case BsonType.DATE
                        fprintf(1, '%s', datestr(i.value));
                    case BsonType.BINDATA
                        fprintf(1, 'BINDATA\n');
                        disp(i.value);
                    case BsonType.UNDEFINED
                        fprintf(1, 'UNDEFINED');
                    case BsonType.NULL
                        fprintf(1, 'NULL');
                    case BsonType.REGEX
                        r = i.value;
                        fprintf(1, '%s, %s', r.pattern, r.options);
                    case BsonType.CODEWSCOPE
                        c = i.value;
                        fprintf(1, 'CODEWSCOPE %s\n', c.code);
                        Bson.display_(c.scope.iterator, depth+1);
                    case BsonType.TIMESTAMP
                        ts = i.value;
                        fprintf(1, '%s (%d)', datestr(ts.date), ts.increment);
                    case {BsonType.INT, BsonType.LONG}
                        fprintf(1, '%d', i.value);
                    case {BsonType.OBJECT, BsonType.ARRAY}
                        fprintf(1, '\n');
                        Bson.display_(i.subiterator, depth+1);
                    otherwise
                        fprintf(1, 'UNKNOWN');
                end
                fprintf(1, '\n');
            end
        end

        function b = empty()
            b = Bson;
            calllib('MongoMatlabDriver', 'mongo_bson_empty', b.h);
        end
    end

    methods
        function b = Bson()
            b.h = libpointer('bson_Ptr');
        end

        function s = size(b)
            if isNull(b.h)
                error('Bson:size', 'Uninitialized BSON');
            end
            s = calllib('MongoMatlabDriver', 'mongo_bson_size', b.h);
        end

        function i = iterator(b)
            if isNull(b.h)
                error('Bson:iterator', 'Uninitialized BSON');
            end
            i = BsonIterator(b);
        end

        function i = find(b, name)
            if isNull(b.h)
                error('Bson:find', 'Uninitialized BSON');
            end
            i = BsonIterator;
            calllib('MongoMatlabDriver', 'mongo_bson_find', b.h, name, i.h);
            if isNull(i.h)
                i = [];
            end
        end

        function v = value(b, name)
            i = b.find(name);
            if isempty(i)
                v = [];
            else
                v = i.value;
            end
        end

        function display(b)
            if ~isNull(b.h)
                b.display_(b.iterator, 0);
            end
        end

        function delete(b)
            calllib('MongoMatlabDriver', 'mongo_bson_free', b.h);
        end

    end
end
