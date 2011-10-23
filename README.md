This is a Matlb extension supporting access to MongoDB.

After cloning the repo, unpack mongo-c-driver-src/mongo-c-driver-src.zip into that directory.
Use the files in this zip file rather than [mongo-c-driver](http://github.com/mongodb/mongo-c-driver),
 since a few minor tweaks were required to get it to work with Matlab.

Load the solution into Visual Studio and build the dll.

Add the path of the driver to Matlab:
`> addpath /10gen/mongo-matlab-driver`

Then the test suite can be run with:
`> MongoTest`

For normal operation, load the library with:
`> MongoStart`

Documentation may be accessed within Matlab by:
`> doc Mongo % for instance`

though you may find it more convenient to examine the class files directly.

Unload the library with:
`> MongoStop`

(you may have to clear variables in order to do this)
