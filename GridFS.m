classdef GridFS < handle
    properties
        h
        mongo  % hold a reference to prevent release %
    end

    methods
        function gfs = GridFS(m, db, varargin)
            if nargin > 3
                error('GridFS:GridFS', 'Too many parameters');
            end
            if nargin == 3
                prefix = varargin{1}
            else
                prefix = 'fs';
            end
            gfs.mongo = m;
            gfs.h = libpointer('gridfs_Ptr');
            if ~calllib('MongoMatlabDriver', 'mongo_gridfs_create', m.h, db, prefix, gfs.h)
                gfs = [];
            end
        end

        function delete(gfs)
            calllib('MongoMatlabDriver', 'mongo_gridfs_destroy', gfs.h);
        end

        function ok = storeFile(gfs, filename, varargin)
            remoteName = filename;
            contentType = '';
            if nargin > 4
                error('GridFS:storeFile', 'Too many arguments');
            end
            if nargin == 4
                contentType = varargin{2};
            end
            if nargin >= 3
                remoteName = varargin{1};
            end
            ok = (calllib('MongoMatlabDriver', 'mongo_gridfs_store_file', gfs.h, filename, remoteName, contentType) ~= 0);
        end

        function removeFile(gfs, remoteName)
            calllib('MongoMatlabDriver', 'mongo_gridfs_remove_file', gfs.h, remoteName)
        end

        function ok = store(gfs, data, remoteName, varargin)
            contentType = '';
            if nargin > 4
                error('GridFS:store', 'Too many arguments');
            end
            if nargin == 4
                contentType = varargin{1};
            end
            ok = (calllib('MongoMatlabDriver', 'mongo_gridfs_store', gfs.h, data, remoteName, contentType) ~= 0);
        end


        function gfw = writerCreate(gfs, remoteName, varargin)
            contentType = '';
            if nargin > 3
                error('GridFS:writerCreate', 'Too many arguments');
            end
            if nargin == 3
                contentType = varargin{1};
            end
            gfw = GridfileWriter(gfs, remoteName, contentType);
        end

        function gf = find(gfs, query)
            gf = Gridfile();
            if class(query) == 'char'
                bb = BsonBuffer;
                bb.append('filename', query);
                query = bb.finish;
            end
            gf.gfs = gfs;
            if ~calllib('MongoMatlabDriver', 'mongo_gridfs_find', gfs.h, query.h, gf.h)
                gf = [];
            end
        end

    end
end
