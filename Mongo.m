classdef Mongo < handle
    properties
        h
    end

    properties (Constant)
        update_upsert = uint32(1);
        update_multi  = uint32(2);
        update_basic  = uint32(4);

        index_unique     = uint32(1);
        index_drop_dups  = uint32(4);
        index_background = uint32(8);
        index_sparse     = uint32(16);

        cursor_tailable   = uint32(2);   % Create a tailable cursor. %
        cursor_slave_ok   = uint32(4);   %*< Allow queries on a non-primary node. %
        cursor_no_timeout = uint32(16);  %*< Disable cursor timeouts. %
        cursor_await_data = uint32(32);  %*< Momentarily block for more data. %
        cursor_exhaust    = uint32(64);  %*< Stream in multiple 'more' packages. %
        cursor_partial    = uint32(128); %*< Allow reads even if a shard is down. %
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
                    host = varargin{1};
                    if ~strcmp('replset', host)
                        error('Mongo:Mongo', 'Expected ''replset'' or a host for 1st parameter');
                    end
                    replset_name = varargin{2}
                otherwise
                    error('Mongo:Mongo', 'Unexpected number of parameters');
            end

            m.h = libpointer('mongo_Ptr');
            calllib('MongoMatlabDriver', 'mongo_create', m.h)
            if strcmp('replset', host)
                calllib('MongoMatlabDriver', 'mmongo_replset_init', m.h, replset_name)
            else
                calllib('MongoMatlabDriver', 'mmongo_connect', m.h, host);
            end
        end

        function delete(m)
            calllib('MongoMatlabDriver', 'mmongo_destroy', m.h);
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

        function b = isConnected(m)
            if isNull(m.h)
                b = false
            else
                b = (calllib('MongoMatlabDriver', 'mongo_is_connected', m.h) ~= 0);
            end
        end

        function b = isMaster(m)
            b = (calllib('MongoMatlabDriver', 'mongo_is_master', m.h) ~= 0);
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

        function socket = getSocket(m)
            socket = calllib('MongoMatlabDriver', 'mongo_get_socket', m.h);
        end

        function hosts = getHosts(m)
            hosts = calllib('MongoMatlabDriver', 'mongo_get_hosts', m.h);
        end

        function err = getErr(m)
            err = calllib('MongoMatlabDriver', 'mongo_get_err', m.h);
        end

        function databases = getDatabases(m)
            databases = calllib('MongoMatlabDriver', 'mongo_get_databases', m.h);
        end

        function collections = getDatabaseCollections(m, db)
            collections = calllib('MongoMatlabDriver', 'mongo_get_database_collections', m.h, db);
        end

        function ok = rename(m, from_ns, to_ns)
            ok = (calllib('MongoMatlabDriver', 'mongo_rename', m.h, from_ns, to_ns) ~= 0);
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
                fields = varargin{1};
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

        function num = count(m, ns, varargin)
            if nargin == 2
                query = Bson;
            elseif nargin == 3
                query = varargin{1};
            else
                error('Mongo:count', 'Unexpected number of parameters');
            end
            num = calllib('MongoMatlabDriver', 'mmongo_count', m.h, ns, query.h);
        end

        function err = indexCreate(m, ns, key, varargin)
            options = uint32(0);
            for i = 1 : size(varargin, 2) 
                options = bitor(options, varargin{i});
            end
            if isa(key, 'char')
                k = BsonBuffer;
                k.append(key, true);
                key = k.finish;
            end
            err = Bson;
            if calllib('MongoMatlabDriver', 'mongo_index_create', m.h, ns, key.h, options, err.h)
                err = [];
            end
        end

        function ok = addUser(m, user, password, varagin)
            db = 'admin';
            if nargin > 4
                error('Mongo:addUser', 'Unexpected number of parameters');
            elseif nargin == 4
                db = varargin{1}
            end
            ok = (calllib('MongoMatlabDriver', 'mongo_add_user', m.h, db, user, password) ~= 0);
        end


        function ok = authenticate(m, user, password, varagin)
            db = 'admin';
            if nargin > 4
                error('Mongo:authenticate', 'Unexpected number of parameters');
            elseif nargin == 4
                db = varargin{1}
            end
            ok = (calllib('MongoMatlabDriver', 'mongo_authenticate', m.h, db, user, password) ~= 0);
        end


        function result = command(m, db, cmd)
            result = Bson;
            if ~calllib('MongoMatlabDriver', 'mongo_command', m.h, db, cmd.h, result.h)
                % result = [];
            end
        end

        function result = simpleCommand(m, db, cmdstr, arg)
            bb = BsonBuffer;
            bb.append(cmdstr, arg);
            cmd = bb.finish;
            result = m.command(db, cmd);
        end

        function err = getLastErr(m, db)
            err = Bson
            if ~calllib('MongoMatlabDriver', 'mongo_get_last_err', m.h, db, err.h)
                err = [];
            end
        end

        function err = getPrevErr(m, db)
            err = Bson
            if ~calllib('MongoMatlabDriver', 'mongo_get_prev_err', m.h, db, err.h)
                err = [];
            end
        end

        function resetErr(m, db)
            m.simpleCommand(db, 'reseterror', true);
        end

        function errNo = getServerErr(m)
            errNo = calllib('MongoMatlabDriver', 'mongo_get_server_err', m.h);
        end

        function errStr = getServerErrString(m)
            errStr = calllib('MongoMatlabDriver', 'mongo_get_server_err_string', m.h);
        end

        function ok = dropDatabase(m, db)
            ok = (calllib('MongoMatlabDriver', 'mongo_drop_database', m.h, db) ~= 0);
        end

        function ok = drop(m, ns)
            ok = (calllib('MongoMatlabDriver', 'mongo_drop', m.h, ns) ~= 0);
        end

    end
end
