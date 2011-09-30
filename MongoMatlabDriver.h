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


EXPORT void mongo_bson_buffer_create(struct bson_buffer** b);
EXPORT int mongo_bson_buffer_append_int(struct bson_buffer* b, char* name, int value);
EXPORT void mongo_bson_buffer_to_bson(struct bson_buffer** b, struct bson_** out);
EXPORT int mongo_bson_size(struct bson_* b);
