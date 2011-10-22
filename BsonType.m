classdef BsonType < uint32
    % BsonType - An enumeration of the types of fields with BSON documents.
    enumeration
        EOO         (0) % End Of Object
        DOUBLE      (1)
        STRING      (2)
        OBJECT      (3)
        ARRAY       (4)
        BINDATA     (5)
        UNDEFINED   (6)
        OID         (7)
        BOOL        (8)
        DATE        (9)
        NULL        (10)
        REGEX       (11)
        DBREF       (12) % Deprecated. %
        CODE        (13)
        SYMBOL      (14)
        CODEWSCOPE  (15)
        INT         (16)
        TIMESTAMP   (17)
        LONG        (18)
    end
end
