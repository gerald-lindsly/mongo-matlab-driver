classdef MongoCursor < handle
    properties
        h
        query
        sort
        fields
        mongo  % hold a reference to prevent release %
        limit   = int32(0)
        skip    = int32(0)
        options = uint32(0)
    end

    properties (Constant)
        % Options: %
        tailable   = uint32(2);   % Create a tailable cursor. %
        slave_ok   = uint32(4);   %*< Allow queries on a non-primary node. %
        no_timeout = uint32(16);  %*< Disable cursor timeouts. %
        await_data = uint32(32);  %*< Momentarily block for more data. %
        exhaust    = uint32(64);  %*< Stream in multiple 'more' packages. %
        partial    = uint32(128); %*< Allow reads even if a shard is down. %
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
            end
        end

    end
end
