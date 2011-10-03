classdef BsonOID
    properties
        value
    end

    methods
        function oid = BsonOID(varargin)
            if nargin == 0
                p = libpointer('uint8Ptr', zeros([1, 12], 'uint8'));
                calllib('MongoMatlabDriver', 'mongo_bson_oid_gen', p);
                oid.value = p.Value;
            elseif nargin ~= 1
                error('BsonOID:BsonOID', 'Expected 0 or 1 parameters');
            else
                parm = varargin{1}
                if isa(parm, 'uint8')
                    if numel(parm) ~= 12
                        error('BsonOID:BsonOID', 'Expected a 12-byte uint8 array');
                    end
                    oid.value = parm;
                elseif isa(parm, 'char')
                    if numel(parm) ~= 24
                        error('BsonOID:BsonOID', 'Expected a 24-digit hex string');
                    end
                    p = libpointer('uint8Ptr', zeros([1, 12], 'uint8'));
                    calllib('MongoMatlabDriver', 'mongo_bson_oid_from_string', parm, p);
                    oid.value = p.Value;
                else
                    error('BsonOID:BsonOID', 'Unexpected type: %s', class(varargin))
                end
            end
        end
        
        function s = toString(oid)
            p = libpointer('uint8Ptr', oid.value);
            s = calllib('MongoMatlabDriver', 'mongo_bson_oid_to_string', p);
        end
    end
end

