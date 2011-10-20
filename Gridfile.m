classdef Gridfile < handle
    properties
        h
        gfs  % hold a reference to prevent release %
    end

    methods
        function gf = Gridfile()
            gf.h = libpointer('gridfile_Ptr');
        end

        function filename = getFilename(gf)
            filename = calllib('MongoMatlabDriver', 'mongo_gridfile_get_filename', gf.h);
        end

        function length = getLength(gf)
            length = calllib('MongoMatlabDriver', 'mongo_gridfile_get_length', gf.h);
        end

        function chunkSize = getChunkSize(gf)
            chunkSize = calllib('MongoMatlabDriver', 'mongo_gridfile_get_chunk_size', gf.h);
        end

        function count = getChunkCount(gf)
            count = calllib('MongoMatlabDriver', 'mongo_gridfile_get_chunk_count', gf.h);
        end

        function type = getContentType(gf)
            type = calllib('MongoMatlabDriver', 'mongo_gridfile_get_content_type', gf.h);
        end

        function date = getUploadDate(gf)
            date = calllib('MongoMatlabDriver', 'mongo_gridfile_get_upload_date', gf.h);
        end

        function md5 = getMD5(gf)
            md5 = calllib('MongoMatlabDriver', 'mongo_gridfile_get_md5', gf.h);
        end

        function b = getDescriptor(gf)
            b = Bson;
            calllib('MongoMatlabDriver', 'mongo_gridfile_get_descriptor', gf.h, b.h);
        end

        function b = getMetadata(gf)
            b = Bson;
            if ~calllib('MongoMatlabDriver', 'mongo_gridfile_get_metadata', gf.h, b.h)
                b = [];
            end
        end

        function b = getChunk(gf, i)
            b = Bson;
            if ~calllib('MongoMatlabDriver', 'mongo_gridfile_get_chunk', gf.h, i, b.h)
                b = [];
            end
        end

        function cursor = getChunks(gf, start, count)
            cursor = MongoCursor()
            calllib('MongoMatlabDriver', 'mongo_gridfile_get_chunks', gf.h, start, count, cursor.h);
        end

        function ok = read(gf, data)
            ok = (calllib('MongoMatlabDriver', 'mongo_gridfile_read', gf.h, data) ~= 0);
        end

        function pos = seek(gf, offset)
            pos = calllib('MongoMatlabDriver', 'mongo_gridfile_seek', gf.h, offset);
        end

        function pos = getPos(gf)
            pos = calllib('MongoMatlabDriver', 'mongo_gridfile_get_pos', gf.h);
        end

        function delete(gfw)
            calllib('MongoMatlabDriver', 'mongo_gridfile_destroy', gfw.h);
        end

    end
end
