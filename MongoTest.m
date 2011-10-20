MongoStart;

x = [1,2,3; 4,5,6]
size(x)
bc = BsonBuffer;
bc.append('mat2x3', x);
z = bc.finish()
i = z.iterator;
v = i.value

y = [.5, 1, 2; 0.6, 1.1, 2.1]
c = complex(x, y);
bc = BsonBuffer;
bc.append('cmat2x3', c);
z = bc.finish()
i = z.iterator;
v = i.value


x = [1;2;3]
bc = BsonBuffer;
bc.append('vmat3x1', x);
z = bc.finish()
i = z.iterator;
v = i.value

x = [1,2,3]
bc = BsonBuffer;
bc.append('hmat1x3', x);
z = bc.finish()
i = z.iterator;
v = i.value

B = cat(3, [1 2 3; 4 5 6], [7 8 9; 10 11 12])
bc = BsonBuffer;
bc.append('mat2x3x2', B);
z = bc.finish()
i = z.iterator;
q = i.value


bc = BsonBuffer;
bc.append('smat2x3x2', single(B));
z = bc.finish()
i = z.iterator;
q = i.value

bc = BsonBuffer;
bc.append('lmat2x3x2', int32(B));
z = bc.finish()
i = z.iterator;
q = i.value
class(q)

lmat4x4 = magic(4) >= 9
bc = BsonBuffer;
bc.append('lmat4x4', lmat4x4);
z = bc.finish()
i = z.iterator;
q = i.value


ba = BsonBuffer;
ba.append('test', 'testing');
y = ba.finish;
y.display();


bb = BsonBuffer;
bb.append('name', 'Gerald');
bb.append('age', int32(48));
bb.append('city', 'Cincinnati');
bb.append('foo', 5);
bb.append('boo', 'buzz');
bb.append('bar', int64(2));
bb.appendBinary('bin', uint8(eye(5)), 1);
oid = BsonOID
bb.append('oid', oid);
bb.append('true', true');
bb.appendDate('date', now);
bb.append('null', []);
bb.append('regex', BsonRegex('pattern', 'options'));
bb.appendCode('code', '{ this = is + code; }');
bb.appendSymbol('symbol', 'symbol');
bb.append('codewscope', BsonCodeWScope('code for scope', y));
bb.append('timestamp', BsonTimestamp(now, 63));

bb.startObject('sub');
bb.append('baz', int32(3));
bb.append('zip', 26);
bb.finishObject;
bb.append('more', 'much');

w = bb.finish;
display(w);

i = w.find('regex');
display(i.value);

i = w.find('notfound');
if ~isempty(i)
    error('MongoTest:Bson.find', 'should have been not found');
end

w.value('oid')
w.value('timestamp')

ds = [now, now + 1];
bc = BsonBuffer;
bc.appendDate('dates', ds);
z = bc.finish()
i = z.iterator;
v = i.value


mongo = Mongo();
if mongo.isConnected
    primary = mongo.getPrimary
    socket = mongo.getSocket
    hosts = mongo.getHosts

    db = 'test';
    % mongo.dropDatabase(db); %

    people = sprintf('%s.people', db);

    mongo.drop(people);

    mongo.insert(people, w);

    bb = BsonBuffer;
    bb.append('name', 'Abe');
    bb.append('age', int32(32));
    bb.append('city', 'Washington');
    x = bb.finish;
    mongo.insert(people, x);

    bb = BsonBuffer;
    bb.append('name', 'Joe');
    bb.append('age', int32(35));
    bb.append('city', 'Natick');
    x = bb.finish;
    mongo.insert(people, x);

    bb = BsonBuffer;
    bb.append('name', 'Jeff');
    bb.append('age', int32(19));
    bb.append('city', 'Florence');
    x = bb.finish;
    mongo.insert(people, x);

    bb = BsonBuffer;
    bb.append('name', 'Harry');
    bb.append('age', int32(35));
    bb.append('city', 'Fort Aspenwood');
    x = bb.finish;
    mongo.insert(people, x);

    bb = BsonBuffer;
    bb.append('name', 'John');
    bb.append('age', int32(21));
    bb.append('city', 'Cincinnati');
    x = bb.finish;
    mongo.insert(people, x);

    bb = BsonBuffer;
    bb.append('name', 'Joe');
    bb.append('age', int32(36));
    bb.append('city', 'Natick');
    x = bb.finish;

    bb = BsonBuffer;
    bb.append('name', 'Joe');
    criteria = bb.finish;
    mongo.update(people, criteria, x);

    bb = BsonBuffer;
    bb.append('age', int32(19));
    criteria = bb.finish;
    mongo.remove(people, criteria);

    mongo.indexCreate(people, 'name', Mongo.index_unique);

    bb = BsonBuffer;
    bb.append('city', true);
    key = bb.finish;
    mongo.indexCreate(people, key);

    bb = BsonBuffer;
    bb.append('city', 'Natick');
    query = bb.finish;
    result = mongo.findOne(people, query)

    cursor = MongoCursor();
    if mongo.find(people, cursor)
        while (cursor.next)
            display(cursor.value);
            fprintf(1, '\n');
        end
    end

    bb = BsonBuffer;
    bb.append('name', 'Harry');
    cursor = MongoCursor(bb.finish);
    bb = BsonBuffer;
    bb.append('name', true);
    bb.append('city', true);
    cursor.fields = bb.finish;
    if mongo.find(people, cursor)
        while (cursor.next)
            display(cursor.value);
            fprintf(1, '\n');
        end
    end

    num = mongo.count(people)

    bb = BsonBuffer;
    bb.append('count', 'people');
    cmd = bb.finish;
    mongo.command(db, cmd)

    mongo.simpleCommand(db, 'count', 'people')

    mongo.resetErr(db);

    mongo.simpleCommand(db, 'forceerror', true)

    mongo.getLastErr(db)

    bb = BsonBuffer;
    bb.append('name', 'dupkey');
    doc = bb.finish;

    mongo.insert(people, doc)
    mongo.insert(people, doc)

    mongo.getLastErr(db)

    mongo.getServerErr
    mongo.getServerErrString

    mongo.getPrevErr(db)

    mongo.resetErr(db)

    mongo.getLastErr(db)

    bb = BsonBuffer;
    bb.startObject('name');
    bb.append('$badop', true);
    bb.finishObject;
    query = bb.finish;
    mongo.findOne(people, query)

    mongo.getServerErrString

    mongo.addUser('Gerald', 'P97gwep16');

    auth = mongo.authenticate('Gerald', 'P97gwep16')

    auth = mongo.authenticate('Gerald', 'BadPass21')

    auth = mongo.authenticate('Unsub', 'BadUser67')

    master = mongo.isMaster

    mongo.getDatabases

    mongo.getDatabaseCollections(db)

    mongo.rename(people, 'test.rename')
    mongo.rename('test.rename', people)
    mongo.rename('noname', 'dontexist')

    mongo.getLastErr('admin');

    m = [1 2 3];

    gfs = GridFS(mongo, 'grid')

    gfs.storeFile('MongoTest.m')
    gfs.storeFile('MongoStart.m')

    gfs.removeFile('MongoTest.m')

    gfs.store(m, 'M')

    gfs.store(lmat4x4, 'lmat4x4');

    gfw = gfs.writerCreate('gfwTest');

    gfw.write(c)
    gfw.finish()

    gf = gfs.find('MongoStart.m')
    filename = gf.getFilename
    length = gf.getLength
    chunkSize = gf.getChunkSize
    chunkCount = gf.getChunkCount
    type = gf.getContentType
    datestr(gf.getUploadDate)
    md5 = gf.getMD5

    gf.getChunk(0)
    gf.getChunk(1) % empty %

    cursor = gf.getChunks(0, 1);
    while (cursor.next)
        display(cursor.value);
    end


    gf = gfs.find('M')
    m = [7 8 9];
    gf.read(m)
    m

    gf = gfs.find('lmat4x4');
    l2mat4x4 = magic(4) <= 3
    gf.read(l2mat4x4);
    l2mat4x4

    gf.seek(4);
    lmat3x3 = magic(3) >= 4
    gf.read(lmat3x3);
    lmat3x3
end
