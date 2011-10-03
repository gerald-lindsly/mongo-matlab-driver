function MongoStart()
    if ~libisloaded('MongoMatlabDriver')
        loadlibrary('MongoMatlabDriver', 'MongoMatlabDriver.h');
    end
end
