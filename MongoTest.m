MongoStart;
bb = BsonBuffer;
bb.append('foo', 5);
bb.append('bar', int64(2));
bb.appendBinary('bin', uint8(eye(5)));
oid = BsonOID;
disp(oid.toString());
bb.append('oid', oid);
bb.append('boo', 'buzz');
bb.startObject('sub');
bb.append('baz', int32(3));
bb.append('zip', 26);
bb.finishObject;
x = bb.finish;
i = BsonIterator(x);
while i.next
    t = i.type;
    if t == BsonType.OBJECT
        disp(i.key);
        j = BsonIterator(i);
        while j.next
            v = j.value;
            disp([j.key, ': (', class(v), ') ']);
            disp(v);
        end
    elseif t == BsonType.BINDATA
        v = i.value;
        disp([i.key, ': (', class(v), '), ']);
        disp(i.binaryType);
        disp(v);
    else
        v = i.value;
        disp([i.key, ': (', class(v), ') ']);
        disp(v);
    end
    display ([]);
end