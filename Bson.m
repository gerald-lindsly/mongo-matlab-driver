classdef Bson
    properties
        h
    end

    methods
        function b = Bson()
            b.h = libpointer('bson_Ptr');
        end

        function s = size(b)
            s = calllib('MongoMatlabDriver', 'mongo_bson_size', b.h);
        end

        function i = iterator(b)
            i = BsonIterator(b);
        end

        function i = find(b, name)
            i = BsonIterator;
            s = calllib('MongoMatlabDriver', 'mongo_bson_find', b.h, name, i.h);
            if isNull(i.h)
                i = [];
            end
        end

        function display_(b, i, depth)
            while i.next()
                t = i.type;
                if t == BsonType.EOO
                    break;
                end
                for j = 1:depth
                    fprintf(1, '    ');
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
                        fprintf(1, '    Scope:\n');
                        c.scope.display()
                    case {BsonType.INT, BsonType.LONG}
                        fprintf('%d', i.value);
                    case {BsonType.OBJECT, BsonType.ARRAY}
                        fprintf(1, '\n');
                        j = i.subiterator;
                        b.display_(j, depth+1);
                        j.clear;
                    otherwise
                        fprintf(1, 'UNKNOWN');
                end
                fprintf(1, '\n');
            end
        end

        function display(b)
            i = b.iterator;
            b.display_(i, 0);
            i.clear
        end

        function clear(b)
            calllib('MongoMatlabDriver', 'mongo_bson_free', b.h);
            clear b.h;
        end

    end
end
