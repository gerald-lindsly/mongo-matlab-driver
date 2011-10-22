classdef BsonCodeWScope
    % BsonCodeWScope - Used for BsonType CODEWSCOPE
    % Objects of this class are detected by BsonBuffer.append() and
    % returned by Bson.value() and BsonIterator.value().
    properties
        code    % Javascript code
        scope   % Bson subobject scope
    end
    methods
        function bcws = BsonCodeWScope(code_, scope_)
            bcws.code = code_;
            bcws.scope = scope_;
        end
    end
end

        