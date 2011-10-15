#include "MongoMatlabDriver.h"
#include "mongo.h"
#include "net.h"

#include <mex.h>

bson empty_bson;

/* Initialize the socket services */
int sock_init() {

#if defined(_WIN32)
    WSADATA wsaData;
    WORD wVers;
#elif defined(SIGPIPE)
    struct sigaction act;
#endif

    static int called_once;
    static int retval;
    if (called_once) return retval;
    called_once = 1;

    bson_empty(&empty_bson);

#if defined(_WIN32)
    wVers = MAKEWORD(1, 1);
    return retval = (WSAStartup(wVers, &wsaData) == 0);
#elif defined(MACINTOSH)
    GUSISetup(GUSIwithInternetSockets);
    return retval = 1;
#elif defined(SIGPIPE)
    retval = 1;
    if (sigaction(SIGPIPE, (struct sigaction *)NULL, &act) < 0)
        retval = 0;
    else if (act.sa_handler == SIG_DFL) {
        act.sa_handler = SIG_IGN;
        if (sigaction(SIGPIPE, &act, (struct sigaction *)NULL) < 0)
            retval = 0;
    }
    return retval;
#endif
}


EXPORT void mongo_create(struct mongo_** conn) {
    mongo* conn_; 
    conn_ = (mongo*)malloc(sizeof(mongo));
    mongo_init(conn_);
    *conn = (struct mongo_*)conn_;
}


EXPORT void mmongo_connect(struct mongo_* conn, char* host) {
    mongo* conn_ = (mongo*)conn;
    mongo_host_port hp;
    mongo_parse_host(host, &hp);
    if (mongo_connect(conn_, hp.host, hp.port) != MONGO_OK)
        mexPrintf("Unable to connect to %s:%d, error code = %d\n", hp.host, hp.port, conn_->err);
}

EXPORT int mongo_isConnected(struct mongo_* conn) {
    mongo* conn_ = (mongo*)conn;
    return conn_->connected;
}


EXPORT void mmongo_destroy(struct mongo_* conn) {
    mongo* conn_ = (mongo*)conn;
    mongo_destroy(conn_);
    free(conn_);
}


EXPORT void mmongo_replset_init(struct mongo_* conn, char* name) {
    mongo* conn_ = (mongo*)conn;
    mongo_replset_init(conn_, name);
}


EXPORT void mongo_add_seed(struct mongo_* conn, char* host) {
    mongo* conn_ = (mongo*)conn;
    mongo_host_port hp;
    mongo_parse_host(host, &hp);
    mongo_replset_add_seed(conn_, hp.host, hp.port);
}


EXPORT int  mmongo_replset_connect(struct mongo_* conn) {
    mongo* conn_ = (mongo*)conn;
    return (mongo_replset_connect(conn_) == MONGO_OK);
}


EXPORT void mmongo_disconnect(struct mongo_* conn) {
    mongo* conn_ = (mongo*)conn;
    mongo_disconnect(conn_);
}


EXPORT int  mmongo_reconnect(struct mongo_* conn) {
    mongo* conn_ = (mongo*)conn;
    return (mongo_reconnect(conn_) == MONGO_OK);
}


EXPORT int  mmongo_check_connection(struct mongo_* conn) {
    mongo* conn_ = (mongo*)conn;
    return (mongo_check_connection(conn_) == MONGO_OK);
}


EXPORT void mongo_set_timeout(struct mongo_* conn, int timeout) {
    mongo* conn_ = (mongo*)conn;
    mongo_set_op_timeout(conn_, timeout);
}


EXPORT int mongo_get_timeout(struct mongo_* conn) {
    mongo* conn_ = (mongo*)conn;
    return conn_->op_timeout_ms;
}


const char* _get_host_port(mongo_host_port* hp) {
    static char _hp[sizeof(hp->host)+12];
    sprintf(_hp, "%s:%d", hp->host, hp->port);
    return _hp;
}


EXPORT const char* mongo_get_primary(struct mongo_* conn) {
    mongo* conn_ = (mongo*)conn;
    return _get_host_port(conn_->primary);
}


EXPORT int mongo_get_err(struct mongo_* conn) {
    mongo* conn_ = (mongo*)conn;
    return conn_->err;
}


EXPORT int mmongo_insert(struct mongo_* conn, char* ns, struct bson_* b) {
    mongo* conn_ = (mongo*)conn;
    bson* b_ = (bson*)b;
    return (mongo_insert(conn_, ns, b_) == MONGO_OK);
}


EXPORT int mmongo_update(struct mongo_* conn, char* ns, struct bson_* criteria, struct bson_* objNew, int flags) {
    mongo* conn_ = (mongo*)conn;
    bson* criteria_ = (bson*) criteria;
    bson* objNew_ = (bson*) objNew;
    return (mongo_update(conn_, ns, criteria_, objNew_, flags) == MONGO_OK);
}


EXPORT int mmongo_remove(struct mongo_* conn, char* ns, struct bson_* criteria) {
    mongo* conn_ = (mongo*)conn;
    bson* criteria_ = (bson*)criteria;
    return (mongo_remove(conn_, ns, criteria_) == MONGO_OK);
}


EXPORT int mmongo_find_one(struct mongo_* conn, char* ns, struct bson_* query, struct bson_* fields, struct bson_** result) {
    mongo* conn_ = (mongo*)conn;
    bson* query_ = (bson*)query;
    bson* fields_ = (bson*)fields;
    bson* out = (bson*)malloc(sizeof(bson));
    if (mongo_find_one(conn_, ns, query_, fields_, out) == MONGO_OK) {
        *result = (struct bson_*)out;
        return 1;
    } else {
        free(out);
        return 0;
    }
}


EXPORT int mmongo_find(struct mongo_* conn, char* ns, struct bson_* query,  struct bson_* sort, struct bson_* fields, int limit, int skip, int options, struct mongo_cursor_** result) {
    mongo* conn_ = (mongo*)conn;
    bson* query_ = (bson*)query;
    bson* sort_ = (bson*)sort;
    bson* fields_ = (bson*)fields;
    mongo_cursor* cursor;

    bson* q = query_;
    bson sorted_query;
    if (sort_ != NULL && bson_size(sort_) > 5) {
        q = &sorted_query;
        bson_init(q);
        if (query_ == NULL)
            query_ = &empty_bson;
        bson_append_bson(q, "$query", query_);
        bson_append_bson(q, "$orderby", sort_);
        bson_finish(q);
    }

    cursor = mongo_find(conn_, ns, q, fields_, limit, skip, options);

    if (q == &sorted_query)
        bson_destroy(&sorted_query);

    if (cursor != NULL) {
        *result = (struct mongo_cursor_*)cursor;
        return 1;
    }
    return 0;
}


EXPORT int mmongo_cursor_next(struct mongo_cursor_* cursor) {
    if (cursor == NULL)
        return 0;

    return (mongo_cursor_next((mongo_cursor*)cursor) == MONGO_OK);
}


EXPORT int mongo_cursor_value(struct mongo_cursor_* cursor, struct bson_** value) {
    mongo_cursor* cursor_ = (mongo_cursor*)cursor;
    bson* data;
    if (!cursor_ || !cursor_->current.data)
        return 0;
    data = (bson*)malloc(sizeof(bson));
    bson_copy(data, &cursor_->current);
    *value = (struct bson_*)data;
    return 1;
}


EXPORT int mongo_drop_database(struct mongo_* conn, char* db) {
    mongo* conn_ = (mongo*)conn;
    return (mongo_cmd_drop_db(conn_, db) == MONGO_OK);
}


EXPORT int mongo_drop(struct mongo_* conn, char* ns) {
    mongo* conn_ = (mongo*)conn;
    char* p = strchr((char*)ns, '.');
    if (!p) {
        mexPrintf("Mongo:drop - Expected a '.' in the namespace.\n");
        return 0;
    }
    *p = '\0';
    return (mongo_cmd_drop_collection(conn_, ns, p+1, NULL) == MONGO_OK);
}

