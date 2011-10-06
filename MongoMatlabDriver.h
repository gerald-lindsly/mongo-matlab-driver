#ifdef _MSC_VER
#ifndef MONGO_USE__INT64
#define MONGO_USE__INT64
#endif
#endif

#include "mongo-c-driver-src\platform.h"

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

struct bson_buffer {
    int dummy;
};

struct bson_ {
    int dummy;
};

struct bson_iterator_ {
    int dummy;
};


EXPORT void mongo_bson_buffer_create(struct bson_buffer** b);
EXPORT int  mongo_bson_buffer_append_int(struct bson_buffer* b, char* name, int value);
EXPORT int  mongo_bson_buffer_append_long(struct bson_buffer* b, char* name, int64_t value);
EXPORT int  mongo_bson_buffer_append_double(struct bson_buffer* b, char* name, double value);
EXPORT int  mongo_bson_buffer_append_string(struct bson_buffer* b, char* name, char* value);
EXPORT int  mongo_bson_buffer_append_binary(struct bson_buffer* b, char* name, int type, void* value, int len);
EXPORT void mongo_bson_oid_gen(void* oid);
EXPORT const char* mongo_bson_oid_to_string(void* oid);
EXPORT void mongo_bson_oid_from_string(char* s, void* oid);
EXPORT int  mongo_bson_buffer_append_oid(struct bson_buffer* b, char* name, void* value);
EXPORT int  mongo_bson_buffer_append_bool(struct bson_buffer* b, char *name, int value);
EXPORT int  mongo_bson_buffer_append_date(struct bson_buffer* b, char *name, int64_t value);
EXPORT int  mongo_bson_buffer_append_null(struct bson_buffer* b, char *name);
EXPORT int  mongo_bson_buffer_append_regex(struct bson_buffer* b, char *name, char* pattern, char* options);
EXPORT int  mongo_bson_buffer_append_code(struct bson_buffer* b, char *name, char* value);
EXPORT int  mongo_bson_buffer_append_symbol(struct bson_buffer* b, char *name, char* value);
EXPORT int  mongo_bson_buffer_append_codewscope(struct bson_buffer* b, char *name, char* code, struct bson_* scope);
EXPORT int  mongo_bson_buffer_start_object(struct bson_buffer* b, char* name);
EXPORT int  mongo_bson_buffer_finish_object(struct bson_buffer* b);
EXPORT void mongo_bson_buffer_to_bson(struct bson_buffer** b, struct bson_** out);
EXPORT int  mongo_bson_size(struct bson_* b);
EXPORT void mongo_bson_free(struct bson_* b);
EXPORT void mongo_bson_iterator_create(struct bson_* b, struct bson_iterator_** i);
EXPORT void mongo_bson_iterator_free(struct bson_iterator_* i);
EXPORT int  mongo_bson_iterator_type(struct bson_iterator_* i);
EXPORT int  mongo_bson_iterator_next(struct bson_iterator_* i);
EXPORT const char* mongo_bson_iterator_key(struct bson_iterator_* i);
EXPORT void mongo_bson_subiterator(struct bson_iterator_* i, struct bson_iterator_** si);
EXPORT int  mongo_bson_iterator_int(struct bson_iterator_* i);
EXPORT int64_t mongo_bson_iterator_long(struct bson_iterator_* i);
EXPORT double mongo_bson_iterator_double(struct bson_iterator_* i);
EXPORT const char* mongo_bson_iterator_string(struct bson_iterator_* i);
EXPORT int  mongo_bson_iterator_bin_type(struct bson_iterator_* i);
EXPORT int  mongo_bson_iterator_bin_len(struct bson_iterator_* i);
EXPORT void mongo_bson_iterator_bin_value(struct bson_iterator_* i, void* v);
EXPORT void mongo_bson_iterator_oid(struct bson_iterator_* i, void* oid);
EXPORT int  mongo_bson_iterator_bool(struct bson_iterator_* i);
EXPORT int64_t  mongo_bson_iterator_date(struct bson_iterator_* i);
EXPORT const char* mongo_bson_iterator_regex(struct bson_iterator_* i);
EXPORT const char* mongo_bson_iterator_regex_opts(struct bson_iterator_* i);
EXPORT const char* mongo_bson_iterator_code(struct bson_iterator_* i);
EXPORT void mongo_bson_iterator_code_scope(struct bson_iterator_* i, struct bson_buffer** b);
