classdef MongoCursor < handle
    properties
        h
        query
        sort
        fields
        limit   = int32(0)
        skip    = int32(0)
        options = uint32(0)
    end

    methods
        function cursor = MongoCursor(varargin)
            cursor.h = libpointer('mongo_cursor_Ptr');
            if nargin > 1
                error('MongoCursor:MongoCursor', 'Too many parameters');
            elseif nargin == 1
                cursor.query = varargin{1};
            end
        end

        function more = next(cursor)
            more = (calllib('MongoMatlabDriver', 'mmongo_cursor_next', cursor.h) ~= 0);
        end

        function v = value(cursor)
            v = Bson;
            if ~calllib('MongoMatlabDriver', 'mongo_cursor_value', cursor.h, v.h)
                v = [];
            end
        end

        function delete(cursor)
            if ~isNull(cursor.h)
                calllib('MongoMatlabDriver', 'mongo_cursor_free', cursor.h);
                clear cursor.h
                cursor.h = [];
            end
            if ~isNull(cursor.query.h)
                cursor.query.clear;
            end
            if ~isNull(cursor.sort.h)
                cursor.sort.clear;
            end
            if ~isNull(cursor.fields.h)
                cursor.fields.clear;
            end
        end

    end
end
