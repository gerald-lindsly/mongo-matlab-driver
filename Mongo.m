classdef Mongo
    properties
        h
    end

    properties (Constant)
      update_upsert = uint32(1);
      update_multi  = uint32(2);
      update_basic  = uint32(4);
   end

    methods
        function m = Mongo(varargin)
            host = '127.0.0.1:27017';
            switch (nargin)
                case 0
                    ;
                case 1
                    host = varargin{1};
                case 2
                    if ~strcmp('replset', varargin{1})
                        error('Mongo:Mongo', 'Expected ''replset'' or a host for 1st parameter');
                    end
                    replset_name = varargin{2}
                otherwise
                    error('Mongo:Mongo', 'Unexpected number of parameters');
            end

            m.h = libpointer('mongo_Ptr');
            calllib('MongoMatlabDriver', 'mongo_create', m.h)
            if strcmp(host, 'replset')
                calllib('MongoMatlabDriver', 'mmongo_replset_init', m.h, replset_name)
            else
                calllib('MongoMatlabDriver', 'mmongo_connect', m.h, host);
            end
        end

        function b = isConnected(m)
            if isNull(m.h)
                b = false
            else
                b = (calllib('MongoMatlabDriver', 'mongo_isConnected', m.h) ~= 0);
            end
        end

        function clear(m)
            calllib('MongoMatlabDriver', 'mmongo_destroy', m.h);
            clear m.h;
            m.h = [];
        end

        function addSeed(m, host)
            calllib('MongoMatlabDriver', 'mongo_add_seed', m.h, host);
        end
        
        function b = connect(m)
            b = (calllib('MongoMatlabDriver', 'mmongo_replset_connect', m.h, host) ~= 0);
        end

        function disconnect(m)
            calllib('MongoMatlabDriver', 'mmongo_disconnect', m.h);
        end

        function b = reconnect(m)
            b = (calllib('MongoMatlabDriver', 'mmongo_reconnect', m.h) ~= 0);
        end

        function b = checkConnection(m)
            b = (calllib('MongoMatlabDriver', 'mmongo_check_connection', m.h) ~= 0);
        end

        function setTimeout(m, timeout)
            calllib('MongoMatlabDriver', 'mongo_set_timeout', m.h, timeout);
        end

        function t = getTimeout(m)
            t = calllib('MongoMatlabDriver', 'mongo_get_timeout', m.h);
        end

        function host = getPrimary(m)
            host = calllib('MongoMatlabDriver', 'mongo_get_primary', m.h);
        end

        function err = getErr(m)
            err = calllib('MongoMatlabDriver', 'mongo_get_err', m.h);
        end

        function ok = insert(m, ns, b)
            ok = (calllib('MongoMatlabDriver', 'mmongo_insert', m.h, ns, b.h) ~= 0);
        end

        function ok = update(m, ns, criteria, objNew, varargin)
            flags = uint32(0);
            for f = 1 : size(varargin, 2) 
                flags = bitor(flags, varargin{f});
            end
            ok = (calllib('MongoMatlabDriver', 'mmongo_update', m.h, ns, criteria.h, objNew.h, flags) ~= 0);
        end

        function ok = remove(m, ns, criteria)
            ok = (calllib('MongoMatlabDriver', 'mmongo_remove', m.h, ns, criteria.h) ~= 0);
        end

        function b = findOne(m, ns, query, varargin)
            if nargin > 4
                error('Mongo:findOne', 'Too many parameters')
            end
            if nargin == 4
                fields = varargin{1}
            else
                fields = Bson;
            end
            b = Bson;
            if ~calllib('MongoMatlabDriver', 'mmongo_find_one', m.h, ns, query.h, fields.h, b.h)
                b = [];
            end
        end

        function found = find(m, ns, cursor)
            if isempty(cursor.query)
                cursor.query = Bson;
            end
            if isempty(cursor.sort)
                cursor.sort = Bson;
            end
            if isempty(cursor.fields)
                cursor.fields = Bson;
            end
            found = (calllib('MongoMatlabDriver', 'mmongo_find', m.h, ns, cursor.query.h, cursor.sort.h, cursor.fields.h, ...
                             cursor.limit, cursor.skip, cursor.options, cursor.h) ~= 0);
        end

        function ok = dropDatabase(m, db)
            ok = (calllib('MongoMatlabDriver', 'mongo_drop_database', m.h, db) ~= 0);
        end

        function ok = drop(m, ns)
            ok = (calllib('MongoMatlabDriver', 'mongo_drop', m.h, ns) ~= 0);
        end

    end
end