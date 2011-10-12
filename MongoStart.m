function MongoStart()
    if ~libisloaded('MongoMatlabDriver')
        [notfound, warnings] = loadlibrary('MongoMatlabDriver', 'MongoMatlabDriver.h');
    end
end
