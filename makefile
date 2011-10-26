OBJS=DllMain.o bson.o mongo.o net.o gridfs.o md5.o encoding.o numbers.o api_bson.o api_mongo.o api_gridfs.o
CC=gcc-4.3
MATLAB=/usr/local/MATLAB/R2011b
INCPATH=$(MATLAB)/extern/include
LIBS=-L$(MATLAB)/bin/glnx86 -lmex -lmx 
CFLAGS=-Wall -fPIC -I$(INCPATH) -DMONGO_HAVE_STDINT

.c.o:
	$(CC) $(CFLAGS) -c $<

MongoMatlabDriver.so: $(OBJS)
	$(CC) -shared -o MongoMatlabDriver.so $(OBJS) $(LIBS)

