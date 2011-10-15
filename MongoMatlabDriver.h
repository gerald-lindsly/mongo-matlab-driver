#ifdef _MSC_VER
#ifndef MONGO_USE__INT64
#define MONGO_USE__INT64
#endif
#endif

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#define _CRT_SECURE_NO_WARNINGS
#else
#define EXPORT
#endif

#include <matrix.h>

#include "mongo-c-driver-src/platform.h"

struct bson_buffer {
    int dummy;
};

struct bson_ {
    int dummy;
};

struct bson_iterator_ {
    int dummy;
};

struct mongo_ {
    int dummy;
};

struct mongo_cursor_ {
    int dummy;
};


EXPORT void mongo_bson_buffer_create(struct bson_buffer** b);
EXPORT void mongo_bson_buffer_free(struct bson_buffer* b);
EXPORT int mongo_bson_buffer_append(struct bson_buffer* b, char* name, mxArray* value);
EXPORT int  mongo_bson_buffer_append_string(struct bson_buffer* b, char* name, char* value);
EXPORT int  mongo_bson_buffer_append_binary(struct bson_buffer* b, char* name, int type, void* value, int len);
EXPORT void mongo_bson_oid_gen(void* oid);
EXPORT const char* mongo_bson_oid_to_string(void* oid);
EXPORT void mongo_bson_oid_from_string(char* s, void* oid);
EXPORT int  mongo_bson_buffer_append_oid(struct bson_buffer* b, char* name, void* value);
EXPORT int  mongo_bson_buffer_append_date(struct bson_buffer* b, char *name, mxArray* value);
EXPORT int  mongo_bson_buffer_append_null(struct bson_buffer* b, char *name);
EXPORT int  mongo_bson_buffer_append_regex(struct bson_buffer* b, char *name, char* pattern, char* options);
EXPORT int  mongo_bson_buffer_append_code(struct bson_buffer* b, char *name, char* value);
EXPORT int  mongo_bson_buffer_append_symbol(struct bson_buffer* b, char *name, char* value);
EXPORT int  mongo_bson_buffer_append_codewscope(struct bson_buffer* b, char *name, char* code, struct bson_* scope);
EXPORT int  mongo_bson_buffer_append_timestamp(struct bson_buffer* b, char *name, int date, int increment);
EXPORT int  mongo_bson_buffer_start_object(struct bson_buffer* b, char* name);
EXPORT int  mongo_bson_buffer_finish_object(struct bson_buffer* b);
EXPORT int  mongo_bson_buffer_start_array(struct bson_buffer* b, char* name);
EXPORT void mongo_bson_buffer_to_bson(struct bson_buffer** b, struct bson_** out);
EXPORT int  mongo_bson_size(struct bson_* b);
EXPORT int  mongo_bson_buffer_size(struct bson_buffer* b);
EXPORT void mongo_bson_free(struct bson_* b);
EXPORT void mongo_bson_find(struct bson_* b, char* name, struct bson_iterator_** i);
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
EXPORT int mongo_bson_iterator_timestamp(struct bson_iterator_* i, int* increment);
EXPORT mxArray* mongo_bson_array_value(struct bson_iterator_* i);

EXPORT int sock_init();
EXPORT void mongo_create(struct mongo_** conn);
EXPORT void mmongo_connect(struct mongo_* conn, char* host);
EXPORT int  mongo_isConnected(struct mongo_* conn);
EXPORT void mmongo_destroy(struct mongo_* conn);
EXPORT void mmongo_replset_init(struct mongo_* conn, char* name);
EXPORT void mongo_add_seed(struct mongo_* conn, char* host);
EXPORT int  mmongo_replset_connect(struct mongo_* conn);
EXPORT void mmongo_disconnect(struct mongo_* conn);
EXPORT int  mmongo_reconnect(struct mongo_* conn);
EXPORT int  mmongo_check_connection(struct mongo_* conn);
EXPORT void mongo_set_timeout(struct mongo_* conn, int timeout);
EXPORT int mongo_get_timeout(struct mongo_* conn);
EXPORT const char* mongo_get_primary(struct mongo_* conn);
EXPORT int mongo_get_err(struct mongo_* conn);
EXPORT int mmongo_insert(struct mongo_* conn, char* ns, struct bson_* b);
EXPORT int mmongo_update(struct mongo_* conn, char* ns, struct bson_* criteria, struct bson_* objNew, int flags);
EXPORT int mmongo_remove(struct mongo_* conn, char* ns, struct bson_* criteria);
EXPORT int mmongo_find_one(struct mongo_* conn, char* ns, struct bson_* query, struct bson_* fields, struct bson_** result);
EXPORT int mmongo_find(struct mongo_* conn, char* ns, struct bson_* query,  struct bson_* sort, struct bson_* fields, int limit, int skip, int options, struct mongo_cursor_** result);
EXPORT int mmongo_cursor_next(struct mongo_cursor_* cursor);
EXPORT int mongo_cursor_value(struct mongo_cursor_* cursor, struct bson_** value);
EXPORT int mongo_drop_database(struct mongo_* conn, char* db);
EXPORT int mongo_drop(struct mongo_* conn, char* ns);
