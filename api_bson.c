#include "MongoMatlabDriver.h"
#include "bson.h"
#include <malloc.h>

EXPORT void mongo_bson_buffer_create(struct _bson_buffer** b)
{
    bson* _b = (bson*)malloc(sizeof(bson));
    bson_init(_b);
    *b = (struct _bson_buffer*)_b;
}


EXPORT void mongo_bson_buffer_to_bson(struct bson_buffer** b, struct bson_** out) {
    bson_finish((bson*) *b);
    *out = (struct bson_*) *b;
    *b = 0;
}


EXPORT int mongo_bson_buffer_append_int(struct bson_buffer* b, char* name, int value) {
    return (bson_append_int((bson*) b, name, value) == BSON_OK);
}


EXPORT int mongo_bson_size(struct bson_* b) {
    return bson_size((bson*) b);
}