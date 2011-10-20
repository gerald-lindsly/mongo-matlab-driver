classdef GridfileWriter < handle
    properties
        h
        gfs  % hold a reference to prevent release %
    end

    methods
        function gfw = GridfileWriter(gfs, remoteName, varargin)
            if nargin > 3
                error('GridfileWriter:GridfileWriter', 'Too many arguments');
            end
            contentType = '';
            if nargin == 3
                contentType = varargin{1};
            end
            gfw.gfs = gfs;
            gfw.h = libpointer('gridfile_Ptr');
            calllib('MongoMatlabDriver', 'mongo_gridfile_writer_create', gfs.h, remoteName, contentType, gfw.h);
        end


        function write(gfw, data)
            calllib('MongoMatlabDriver', 'mongo_gridfile_writer_write', gfw.h, data);
        end

        function ok = finish(gfw)
            if ~isempty(gfw.h) && ~isNull(gfw.h)
                ok = (calllib('MongoMatlabDriver', 'mongo_gridfile_writer_finish', gfw.h) ~= 0);
                gfw.h = [];
            else
                ok = true;
            end
        end

        function delete(gfw)
            gfw.finish();
        end
    end
end