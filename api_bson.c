#include "MongoMatlabDriver.h"
#include "bson.h"
#include <malloc.h>

EXPORT void mongo_bson_buffer_create(struct bson_buffer** b)
{
    bson* _b = (bson*)malloc(sizeof(bson));
    bson_init(_b);
    *b = (struct bson_buffer*)_b;
}


EXPORT void mongo_bson_buffer_to_bson(struct bson_buffer** b, struct bson_** out) {
    bson_finish((bson*) *b);
    *out = (struct bson_*) *b;
    *b = 0;
}


EXPORT void mongo_bson_free(struct bson_* b) {
    bson_destroy((bson*)b);
    free(b);
}


EXPORT int mongo_bson_buffer_append_int(struct bson_buffer* b, char* name, int value) {
    return (bson_append_int((bson*) b, name, value) == BSON_OK);
}


EXPORT int mongo_bson_buffer_append_long(struct bson_buffer* b, char* name, int64_t value) {
    return (bson_append_long((bson*) b, name, value) == BSON_OK);
}


EXPORT int mongo_bson_buffer_append_string(struct bson_buffer* b, char* name, char* value) {
    return (bson_append_string((bson*) b, name, value) == BSON_OK);
}


EXPORT int mongo_bson_buffer_append_double(struct bson_buffer* b, char* name, double value) {
    return (bson_append_double((bson*) b, name, value) == BSON_OK);
}


EXPORT int mongo_bson_buffer_append_binary(struct bson_buffer* b, char* name, int type, void* value, int len) {
    return (bson_append_binary((bson*) b, name, type, (const char*) value, len) == BSON_OK);
}


EXPORT int mongo_bson_buffer_append_oid(struct bson_buffer* b, char* name, void* value) {
    return (bson_append_oid((bson*) b, name, (bson_oid_t*) value) == BSON_OK);
}


EXPORT int mongo_bson_buffer_start_object(struct bson_buffer* b, char* name) {
    return (bson_append_start_object((bson*) b, name) == BSON_OK);
}


EXPORT int mongo_bson_buffer_finish_object(struct bson_buffer* b) {
    return (bson_append_finish_object((bson*) b) == BSON_OK);
}


EXPORT int mongo_bson_size(struct bson_* b) {
    return bson_size((bson*) b);
}


EXPORT void mongo_bson_iterator_create(struct bson_* b, struct bson_iterator_** i) {
    bson_iterator* _i = (bson_iterator*)malloc(sizeof(bson_iterator));
    bson_iterator_init(_i, (bson*) b);
    *i = (struct bson_iterator_*)_i;
}


EXPORT void mongo_bson_iterator_free(struct bson_iterator_* i) {
    free(i);
}


EXPORT int  mongo_bson_iterator_type(struct bson_iterator_* i) {
    return bson_iterator_type((bson_iterator*) i);
}


EXPORT int  mongo_bson_iterator_next(struct bson_iterator_* i) {
    return bson_iterator_next((bson_iterator*) i);
}


EXPORT const char* mongo_bson_iterator_key(struct bson_iterator_* i) {
    return bson_iterator_key((bson_iterator*) i);
}


EXPORT void mongo_bson_subiterator(struct bson_iterator_* i, struct bson_iterator_** si) {
    bson_iterator* sub = (bson_iterator*)malloc(sizeof(bson_iterator));
    bson_iterator_subiterator((bson_iterator*)i, sub);
    *si = (struct bson_iterator_*)sub;
}


EXPORT int mongo_bson_iterator_int(struct bson_iterator_* i) {
    return bson_iterator_int((bson_iterator*)i);
}


EXPORT int64_t mongo_bson_iterator_long(struct bson_iterator_* i) {
    return bson_iterator_long((bson_iterator*)i);
}


EXPORT double mongo_bson_iterator_double(struct bson_iterator_* i) {
    return bson_iterator_double((bson_iterator*)i);
}


EXPORT const char* mongo_bson_iterator_string(struct bson_iterator_* i) {
    return bson_iterator_string((bson_iterator*)i);
}


EXPORT int mongo_bson_iterator_bin_type(struct bson_iterator_* i) {
    return bson_iterator_bin_type((bson_iterator*)i);
}


EXPORT int mongo_bson_iterator_bin_len(struct bson_iterator_* i) {
    return bson_iterator_bin_len((bson_iterator*)i);
}


EXPORT void mongo_bson_iterator_bin_value(struct bson_iterator_* i, void* v) {
    int len = bson_iterator_bin_len((bson_iterator*)i);
    memcpy(v, bson_iterator_bin_data((bson_iterator*)i), len);
}


EXPORT void mongo_bson_oid_gen(void* oid) {
    bson_oid_gen((bson_oid_t*) oid);
}


EXPORT const char* mongo_bson_oid_to_string(void* oid) {
    static char s[25];
    bson_oid_to_string((bson_oid_t*) oid, s);
    return s;
}


EXPORT void mongo_bson_oid_from_string(char* s, void* oid) {
    bson_oid_from_string((bson_oid_t*) oid, s);
}


EXPORT void mongo_bson_iterator_oid(struct bson_iterator_* i, void* oid) {
    memcpy(oid, bson_iterator_oid((bson_iterator*) i), 12);
}